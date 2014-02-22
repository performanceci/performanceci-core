class BuildEndpointsController < ApplicationController
  before_action :set_build_endpoint, only: [:show, :edit, :update, :destroy]

  # GET /build_endpoints
  # GET /build_endpoints.json
  def index
    @build_endpoints = BuildEndpoint.all
  end

  # GET /build_endpoints/1
  # GET /build_endpoints/1.json
  def show
  end

  # GET /build_endpoints/new
  def new
    @build_endpoint = BuildEndpoint.new
  end

  # GET /build_endpoints/1/edit
  def edit
  end

  # POST /build_endpoints
  # POST /build_endpoints.json
  def create
    @build_endpoint = BuildEndpoint.new(build_endpoint_params)

    respond_to do |format|
      if @build_endpoint.save
        format.html { redirect_to @build_endpoint, notice: 'Build endpoint was successfully created.' }
        format.json { render action: 'show', status: :created, location: @build_endpoint }
      else
        format.html { render action: 'new' }
        format.json { render json: @build_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /build_endpoints/1
  # PATCH/PUT /build_endpoints/1.json
  def update
    respond_to do |format|
      if @build_endpoint.update(build_endpoint_params)
        format.html { redirect_to @build_endpoint, notice: 'Build endpoint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @build_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /build_endpoints/1
  # DELETE /build_endpoints/1.json
  def destroy
    @build_endpoint.destroy
    respond_to do |format|
      format.html { redirect_to build_endpoints_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build_endpoint
      @build_endpoint = BuildEndpoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_endpoint_params
      params.require(:build_endpoint).permit(:endpoint_id, :build_id, :data, :response_time, :score, :screenshot)
    end
end
