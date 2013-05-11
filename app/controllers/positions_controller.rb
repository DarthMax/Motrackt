class PositionsController < ApplicationController

  # POST /positions
  # POST /positions.json
  def create
    @position = current_user.positions.new(params[:position])
    @position.track= get_track

    respond_to do |format|
      if @position.save
        format.json { render json: @position, status: :created, position: @position }
      else
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
    end
  end


  private

  def get_track
    max_delay_time= params[:max_track_delay_time]? params[:max_track_delay_time].to_i : 1440
    puts max_delay_time
    lease_time = max_delay_time.minutes.ago

    track=current_user.tracks.last

    if !track or track.newer_then lease_time
      track= current_user.tracks.new
      track.vehicle = Vehicle.find_by_id params[:vehicle_id] if Vehicle.exists? params[:vehicle_id]
    end

    track
  end
end
