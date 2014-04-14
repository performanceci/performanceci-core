
class BuildWorker < Worker
    include Resque::Plugins::Status
    @queue = "docker"

    def perform
      paas = nil
      project_src = nil
      begin
        build = Build.find(options['build_id'])

        if remote
          project_src = GitCheckout.new.retrieve(build.repository.full_name, build.url)
        else
          project_src = LocalCheckout.new.retrieve(build.repository.full_name, build.url)
        end

        account_data = build.account_data
        if build.provider == :heroku
          paas = HerokuBuilder.new(project_src, account_data)
        else
          paas = DockerBuilder.new(project_src, account_data)
        end

        configuation = ProjectConfiguration.new.parse_configuration(project_src)

        build_result = BuildResult.new(build)

        if configuration.valid?
          endpoint_tests = HttpLoadTester.new(paas.test_url, configuration)
          build_result.tests = endpoint_tests
          build_results.save
        else
          build_results.errors = configuration.errors
          build_results.save
        end
      ensure
        if project_src
          GitCheckout.new.cleanup(project_src)
        end
        if paas
          paas.destroy
        end
      end
    end

      # checkout project from git / gitlab / local etc
      # allow local repo

      # bring up instance of app using paas
        # blocking / non blocking?
        # heroku - pass env variables
            # create app / destroy app
            # save app info for cleanup
            # destroy app
            # save build logs
        # where to save / configure variables for heroku?
        # docker
            # user docker builder docker image
            # docker run etc...
            # how to keep track of duplicate ports? (redis?)
            # cleanup
        # return base URL for testing
        # or failure of app
        # save run logs after test
      # reaper worker

      # test instance using tester
        # bring up docker instance
        # test against endpoints
        # get results
        # parse and save

      # relay status info back to main server (API)
        # either save object directly (not ideal) OR:
        # /builds/123/endpoints POST
        # /builds/123/build_endpoints POST
        # /builds/123/status POST
=begin
      unless ENV['DOCKER_URL']
        ENV['DOCKER_URL'] = 'unix:///var/run/docker.sock'
      end
      Docker.url = ENV['DOCKER_URL']

      build = Build.find(options['build_id'])
      url   = build.url
      repo  = build.repository.full_name
      root  = ENV['WORKSPACE'] || Dir.tmpdir
      host  = ENV['HOST']      || 'localhost'
      if ENV['EXPORT_PORT']
        port = ENV['EXPORT_PORT']
      else
        port  = rand(8000..8999)
      end

      base      = "#{root}/#{build.id}"
      workspace = "#{base}/#{repo}"

      at(0, 9, "Cleaning up workspace")
      build.update_status(:pending, 0)
      FileUtils.rm_r base if Dir.exists? base


      if ENV['LOCAL_WORKSPACE']
        Worker.system_quietly("mkdir #{base}")
        workspace = base + "/" + ENV['LOCAL_WORKSPACE'].split('/').last
        Worker.system_quietly("cp -R #{ENV['LOCAL_WORKSPACE']} #{workspace}")
        at(1, 9, "cp -R #{ENV['LOCAL_WORKSPACE']} #{workspace}")
      else
        at(1, 9, "Cloning Repo")
        Git.clone(url, workspace)
      end
      # Check for Dockerfile and perfci.yaml
      ['Dockerfile', '.perfci.yaml'].each do |file|
        if !File.exists? "#{workspace}/#{file}"
          build.mark_build_error("#{file} does not exist")
          raise "#{file} does not exist"
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
      rescue Docker::Error::DockerError => e
        puts "Error: #{e.to_s}\n#{e.backtrace}"
        build.mark_build_error(e.to_s + "\n" + e.backtrace.to_s)
        raise e
      end

      at(3, 9, "Running container")
      begin
        container_id = Worker.system_quietly("docker run -d -p 0.0.0.0:#{port}:4567 #{image.id}")
      rescue Shell::Error => e
        puts "Error: #{e.backtrace}"
        build.mark_build_error(e.backtrace.to_s)
        raise e
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
        puts "Error: #{e.to_s}\n#{e.backtrace}"
        container.kill
        build.mark_build_error(e.to_s + "\n" + e.backtrace.to_s)
        raise e
      end

      at(7, 9, "Killing container")
      container.kill

      at(8, 9, "Cleaning workspace")
      FileUtils.rm_r base
      build.mark_build_finished
      puts "Performance Tested!"
    end
=end
end
