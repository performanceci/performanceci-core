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
        response = Net::HTTP.get_response(URI(url))
      end
      finish = Time.now


      case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        fetch(location, limit - 1)
      else
        response.value
      end
      diff = (finish - start) / 10
    end
end
