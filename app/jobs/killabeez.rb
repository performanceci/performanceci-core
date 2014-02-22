require_relative 'worker/worker'

class KillaBeez < Worker
    include Resque::Plugins::Status
    @queue = "beezAttackQueue"
    def perform
        at(0, 1, "Sleepy Beez")
        cmd = options['cmd']

        Worker.system_quietly("#{cmd}") 
        puts "done"
    end
end
