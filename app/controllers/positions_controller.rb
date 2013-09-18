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

  #return the track which the position will belong to
  #If the last position entry is older than max_track_delay_time (default 300 minutes) a new Track will be started
  def get_track
    max_delay_time = params[:max_track_delay_time].to_i
    max_delay_time = 300 if max_delay_time<=0

    lease_time = max_delay_time.minutes.ago

    position = current_user.positions.order("created_at desc").first

    if !position or position.created_at < lease_time
      track= current_user.tracks.new
      track.vehicle = Vehicle.find_by_id params[:vehicle_id] if Vehicle.exists? params[:vehicle_id]
    else
      track = position.track
    end

    track
  end
end
