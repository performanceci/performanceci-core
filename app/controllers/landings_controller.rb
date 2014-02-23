class LandingsController < ApplicationController
  layout 'login'

  def redirects
    if signed_in?
      redirect_to results_overview_index_path
    else
      redirect_to "http://performanceci.github.io"
    end
  end
end