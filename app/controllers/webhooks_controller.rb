class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def hook
    puts params[:payload]
  end
end