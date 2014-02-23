require_relative '../jobs/docker.rb'
class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def hook
    build = Build.from_payload(params)
    build.save!
    if ENV['GENERATE_DATA']
      build.generate_fake_data(10)
    end
    DockerWorker.create(
      :url => build.url,
      :repo => build.repository.name
    )
    render :text => 'OK', :status => 200
  end
end
