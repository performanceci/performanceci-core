require_relative '../jobs/killabeez.rb'

class JobTestController < ApplicationController
    def swarm
        KillaBeez.create(:cmd => 'sleep 5')
        
        render text: "KillaBeez on the loose!"
    end
end
