require 'net/http'

class KillaBeez < Worker
    include Resque::Plugins::Status
    @queue = "beezAttackQueue"
    def perform
      host      = options['host']      || 'localhost'
      endpoints = options['endpoints'] || ['/', '/test']
      port      = options['port']      || '4567'
      attacks   = options['attacks']   || 5

      at(0, 1, "Killa Beez on the swarm")
      respone_time = endpoints.map do |uri|
        attack("http://#{host}:#{port}#{uri}", attacks)
      end
      completed(:latency => respone_time)
      puts "Attack finished"
    end

    def attack(url, attacks)
      start = Time.now
      attacks.times.each do |time|
        Net::HTTP.get_response(URI(url))
      end
      (Time.now - start) / attacks
    end
end
