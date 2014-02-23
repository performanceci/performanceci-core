class ResultsOverviewController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  # GET /results_overview
  # GET /results_overview.json
  def index
    @repositories = Repository.all
  end

  # GET /results_overview/1
  # GET /results_overview/1.json
  def show
  end

  # GET /results_overview/new
  def new
    @repositories = current_user.github_client.repos
  end

  # GET /results_overview/1/edit
  def edit
  end

  # POST /results_overview
  # POST /results_overview.json
  def create
    @repository = Repository.new(name: params[:name], full_name: params[:full_name],
      :github_id => params[:github_id], user: current_user)

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render action: 'show', status: :created, location: @repository }
      else
        format.html { render action: 'new' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results_overview/1
  # PATCH/PUT /results_overview/1.json
  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results_overview/1
  # DELETE /results_overview/1.json
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.permit(:name, :url)
    end

end
