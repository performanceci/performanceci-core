
class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def hook
    build = Build.from_payload(params)
    build.save!
    build.run_build
    render :text => 'OK', :status => 200
  end
end
