require_relative 'Worker/worker'

class DockerWorker < Worker
    include Resque::Plugins::Status
    @queue = "docker"
    def perform
        at(0, 1, "Initialize build")
        cmd = options['cmd']

        Worker.system_quietly("#{cmd}")
        puts "Started docker"
    end
end
