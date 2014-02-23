require_relative 'Worker/worker'
require 'net/http'

class KillaBeez < Worker
    include Resque::Plugins::Status
    @queue = "beezAttackQueue"
    def perform
        at(0, 1, "Sleepy Beez")
        url = options['url']
        start = Time.now
        response = Net::HTTP.get_response(URI(url))

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
        finish = Time.now
        diff = finish - start
        completed(:latency => diff)
        #Worker.system_quietly("#{cmd}")
        puts "done"
    end
end
