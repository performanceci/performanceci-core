class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def hook
    Build.from_payload(params).save!
    render :text => 'OK', :status => 200
  end
end