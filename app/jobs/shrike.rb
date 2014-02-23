require_relative 'Worker/worker'

class ShrikeWorker < Worker
    include Resque::Plugins::Status
    @queue = "shrike"
    def perform
        at(0, 1, "Killing procs")
        cmd = options['cmd']

        Worker.system_quietly("#{cmd}")
        puts "kilt"
    end
end
