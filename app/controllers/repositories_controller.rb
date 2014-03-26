class RepositoriesController < ApplicationController
  before_filter :authenticate_user!

  protect_from_forgery except: [:build_latest]
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show

  end

  def build_latest
    @repository = current_user.repositories.find(params[:id])
    build = @repository.build_from_last_commit
    render json: build
  end

  def summary
    @repository = current_user.repositories.find(params[:id])
    render json: @repository.build_summary
  end

  # GET /repositories/new
  def new
    @repositories = current_user.github_client.repos
    @current_repositories = current_user.repositories
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(name: params[:name], full_name: params[:full_name],
      :github_id => params[:github_id], user: current_user)

    respond_to do |format|
      if @repository.save
        @repository.add_hook
        format.html { redirect_to results_overview_index_path, notice: 'Repository was successfully created.' }
        format.json { render action: 'show', status: :created, location: @repository }
      else
        format.html { render action: 'new' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
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

  # DELETE /repositories/1
  # DELETE /repositories/1.json
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
