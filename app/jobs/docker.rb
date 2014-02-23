require_relative 'Worker/worker'
require_relative 'killabeez'
ENV['DOCKER_URL'] = 'unix:///var/run/docker.sock'
require 'docker'
require 'git'

class DockerWorker < Worker
    include Resque::Plugins::Status
    @queue = "docker"
    def perform
      at(0, 9, "Cleaning up workspace")
      url = options['url']
      repo = options['repo']
      path = "/tmp/#{repo}"
      host = 'http://23.253.97.212'
      port = '4567'
      endpoints = ["#{host}:#{port}/", "#{host}:#{port}/test"]
      build = Build.find(options['build_id'])
      build_endpoints = endpoints.map do |url|
        build.add_endpoint(url, {})
      end

      Worker.system_quietly("rm -rf #{path}")

      at(1, 9, "Cloning Repo")
      Git.clone(url, path)

      at(2, 9, "Building container")
      image = Docker::Image.build_from_dir(path)
      begin
        image.tag(:tag => 'latest')
      rescue Exception => e
        puts "Error #{e}"
      end

      at(3, 9, "Running container")
      container_id = Worker.system_quietly("docker run -d -p 0.0.0.0:4567:4567 #{image.id}")
      puts container_id


      at(4, 9, "Creating Beez")
      job_ids = 6.times.collect do
          KillaBeez.create(:endpoints => endpoints)
      end
      at(5, 9, "Attacking container")
      sleep 60
      statuses = job_ids.map do |job_id|
        status = Resque::Plugins::Status::Hash.get(job_id)
        status['latency']
      end

      latency = []
      count = 0
      at(6, 9, "Storing stats")
      build_endpoints.each do |endpoint|
        latencies = statuses.map { |lat|  lat[count] }
        latency[count] = latencies.reduce(:+)
        latency[count] = latency[count] / 6
        build.endpoint_benchmark(endpoint, latency[count], 0, [])
        count += 1
      end

      at(7, 9, "Killing container")
      container = Docker::Container.get(container_id)
        container.kill
      begin
        image.remove
      rescue Exception => e
        puts "Error #{e}"
      end

      at(8, 9, "Cleaning workspace")
      Worker.system_quietly("rm -rf #{path}")
      puts "Performance Tested!"
    end
end
