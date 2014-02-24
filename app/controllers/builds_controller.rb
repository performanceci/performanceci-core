class BuildsController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_build, only: [:show, :edit, :update, :destroy]

  # GET /builds
  # GET /builds.json
  def index
    @builds = Build.all
    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @builds.to_json}
    end
  end

  def ongoing
    @builds = Build.scoped.select(:id, :build_status, :percent_done)
    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @builds.to_json}
    end

  end


  # GET /builds/1
  # GET /builds/1.json
  def show
  end

  # GET /builds/new
  def new
    @build = Build.new
  end

  # GET /builds/1/edit
  def edit
  end

  # POST /builds
  # POST /builds.json
  def create
    @build = Build.new(build_params)

    respond_to do |format|
      if @build.save
        format.html { redirect_to @build, notice: 'Build was successfully created.' }
        format.json { render action: 'show', status: :created, location: @build }
      else
        format.html { render action: 'new' }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /builds/1
  # PATCH/PUT /builds/1.json
  def update
    respond_to do |format|
      if @build.update(build_params)
        format.html { redirect_to @build, notice: 'Build was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /builds/1
  # DELETE /builds/1.json
  def destroy
    @build.destroy
    respond_to do |format|
      format.html { redirect_to builds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build
      @build = Build.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_params
      params.require(:build).permit(:ref, :before, :after, :repository_id, :message, :url, :author, :payload)
    end
end
