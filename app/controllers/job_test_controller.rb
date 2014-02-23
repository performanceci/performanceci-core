require_relative '../jobs/killabeez.rb'
require_relative '../jobs/docker.rb'

class JobTestController < ApplicationController
    def swarm
        KillaBeez.create(:cmd => 'sleep 5')

        render text: "KillaBeez on the loose!"
    end
    def docker
        DockerWorker.create(:cmd => 'docker -v')

        render text: "Docker is better"
    end
end
