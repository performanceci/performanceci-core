require_relative 'Worker/worker'
ENV['DOCKER_URL'] = 'unix:///var/run/docker.sock'
require 'docker'
require 'git'

class DockerWorker < Worker
    include Resque::Plugins::Status
    @queue = "docker"
    def perform
      at(0, 3, "Cloning Repo")
      url = options[:url]
      repo = options[:repo]
      path = "/tmp#{repo}"
      Git.clone(url, path)
      at(1, 3, "Building container")
      Docker::Image.build_from_dir('.')
      at(2, 3, "Cleaning repo")
      Worker.system_quietly("rm -rf #{path}")
      puts "Container built"
    end
end
