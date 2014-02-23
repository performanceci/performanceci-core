require_relative 'Worker/worker'
require_relative 'killabeez'
ENV['DOCKER_URL'] = 'unix:///var/run/docker.sock'
require 'docker'
require 'git'

class DockerWorker < Worker
    include Resque::Plugins::Status
    @queue = "docker"
    def perform
      at(0, 3, "Cloning Repo")
      url = options['url']
      repo = options['repo']
      path = "/tmp/#{repo}"
      Worker.system_quietly("rm -rf #{path}")
      Git.clone(url, path)
      at(1, 3, "Building container")
      image = Docker::Image.build_from_dir(path)
      #container = image.run()
      Worker.system_quietly("docker -d -p 0.0.0.0:4567:4567 #{image.id}")
      puts ("docker run -d -p 0.0.0.0:4567:4567 #{image.id}")
      job_id = KillaBeez.create(:url => 'http://23.253.97.212:4567/test')
      while status = Resque::Plugins::Status::Hash.get(job_id) and !status.completed? && !status.failed?
        sleep 3
        puts status.inspect
      end
      at(2, 3, "Cleaning repo")
      Worker.system_quietly("rm -rf #{path}")
      puts "Container built"
    end
end
