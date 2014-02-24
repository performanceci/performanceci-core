class ResultsOverviewController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  # GET /results_overview
  # GET /results_overview.json
  def index
    @repositories = Repository.all
    if params[:repository_id]
      @repository = Repository.find(params[:repository_id])
    else
      @repository = Repository.first
    end
    if @repository
      @build = @repository.last_build
    end
  end
end
