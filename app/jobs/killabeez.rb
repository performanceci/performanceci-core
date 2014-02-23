require_relative 'Worker/worker'
require 'net/http'

class KillaBeez < Worker
    include Resque::Plugins::Status
    @queue = "beezAttackQueue"
    def perform
      at(0, 1, "Sleepy Beez")
      endpoints = options['endpoints']

      respone_time = endpoints.map { |u| attack(u) }
      completed(:latency => respone_time)
      puts "done"
    end
    def attack(url)

      start = Time.now
      10.times.each do |time|
        Net::HTTP.get_response(URI(url))
      end
      finish = Time.now
      diff = (finish - start) / 10
    end
end
