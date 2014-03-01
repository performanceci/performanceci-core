require_relative 'Worker/worker'
require_relative 'killabeez'
ENV['DOCKER_URL'] = 'unix:///var/run/docker.sock'
require 'fileutils'
require 'docker'
require 'git'
require 'yaml'

class DockerWorker < Worker
    include Resque::Plugins::Status
    @queue = "docker"
    def perform

      build = Build.find(options['build_id'])
      url   = build.url
      repo  = build.repository.full_name
      root  = ENV['WORKSPACE'] || '/var/cache/workspace'
      host  = ENV['HOST']      || 'localhost'
      port  = rand(8000..8999)

      base      = "#{root}/#{build.id}"
      workspace = "#{base}/#{repo}"

      at(0, 9, "Cleaning up workspace")
      build.update_status(:pending, 0)
      FileUtils.rm_r base if Dir.exists? base

      at(1, 9, "Cloning Repo")
      Git.clone(url, workspace)
      # Check for Dockerfile and perfci.yaml
      ['Dockerfile', '.perfci.yaml'].each do |file|
        if !File.exists? "#{workspace}/#{file}"
          build.mark_build_error("#{file} does not exist")
          return
        end
      end

      # Read endpoints from perfci.yaml
      conf = File.read("#{workspace}/.perfci.yaml")
      yaml_hash = YAML.load(conf)
      endpoints = (yaml_hash['endpoints'] || []).map { |endpoint| endpoint }
      build_endpoints = endpoints.map do |endpoint|
        build.add_endpoint(
          endpoint['uri'],
          {},
          :max_response_time    => (endpoint['max_response_time']    || 0.01),
          :target_response_time => (endpoint['target_response_time'] || 0.001)
        )
      end

      at(2, 9, "Building container")
      build.update_status(:building_container, 20)
      begin
        image = Docker::Image.build_from_dir(workspace)
      rescue Docker::Error => e
        puts "Error: #{e}"
        build.mark_build_error(e.backtrace)
        return
      end

      at(3, 9, "Running container")
      begin
        container_id = Worker.system_quietly("docker run -d -p 0.0.0.0:#{port}:4567 #{image.id}")
      rescue Shell::Error => e
        puts "Error: #{e}"
        build.mark_build_error(e.backtrace)
        return
      end
      container = Docker::Container.get(container_id)

      at(4, 9, "Signaling KillaBeez")
      build.update_status(:attacking_container, 40)
      endpoints = endpoints.map { |e| e['uri'] }
      job_ids = 6.times.collect do
          KillaBeez.create(:endpoints => endpoints, :host => host, :port => port)
      end

      at(5, 9, "Collecting data")
      statuses = job_ids.map do |job_id|
        status = Resque::Plugins::Status::Hash.get(job_id)
        while !status.completed? && !status.failed? do
          sleep 1
          status = Resque::Plugins::Status::Hash.get(job_id)
        end
        status['latency']
      end

      at(6, 9, "Storing stats")
      begin
        latency = []
        count = 0
        build_endpoints.each do |endpoint|
          latencies = statuses.map { |lat|  lat[count] }
          latency[count] = latencies.reduce(:+)
          latency[count] = latency[count] / 6
          build.endpoint_benchmark(endpoint, latency[count], 0, [])
          count += 1
        end
      rescue Exception => e
        puts "Error: #{e}"
        puts "Type: #{e.inspect}"
        container.kill
        build.mark_build_error(e.backtrace)
        return
        raise e
      end

      at(7, 9, "Killing container")
      container.kill

      at(8, 9, "Cleaning workspace")
      FileUtils.rm_r base
      build.mark_build_finished
      puts "Performance Tested!"
    end
end
