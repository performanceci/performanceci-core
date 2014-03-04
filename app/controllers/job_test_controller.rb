
class JobTestController < ApplicationController
  def swarm
    KillaBeez.create(:cmd => 'sleep 5')

    render text: "KillaBeez on the loose!"
  end

  def docker
    DockerWorker.create(
      :url => 'https://github.com/performanceci/simple.git',
      :repo => 'simple'
    )
    render text: "Docker is better"
  end
end
