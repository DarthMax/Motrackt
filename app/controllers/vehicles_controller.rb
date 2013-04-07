class VehiclesController < ApplicationController
  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = current_user.vehicles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vehicles }
    end
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    @vehicle = current_user.vehicles.find!(params[:id])

    if @vehicle.tracks.empty?
      redirect_to(vehicles_url, :notice => "No position data found")
      return
    end

    @position=@vehicle.tracks.last.positions.last

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vehicle }
    end
  end

  # GET /vehicles/new
  # GET /vehicles/new.json
  def new
    @vehicle = current_user.vehicles.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @vehicle }
    end
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = current_user.vehicles.new(params[:vehicle])

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to vehicle_path, notice: 'Vehicle was successfully created.' }
        format.json { render json: vehicle_path, status: :created, location: @vehicle }
      else
        format.html { render action: "new" }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle = current_user.vehicles.find!(params[:id])
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :no_content }
    end
  end
end
