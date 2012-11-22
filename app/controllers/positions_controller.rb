class PositionsController < ApplicationController

  def new
    @position = current_user.positions.new

    respond_to do |format|
      format.html
    end
  end


  # POST /positions
  # POST /positions.json
  def create
    @position = current_user.positions.new(params[:position])

    lease_time = params[:max_track_delay_time].to_i.minutes.ago || 30.minutes.ago
    track=current_user.tracks.last

    if track
      track= track.older_then(lease_time)? track : current_user.tracks.new
    else
      track= current_user.tracks.new
    end


    @position.track= track


    respond_to do |format|
      if @position.save
        format.html { redirect_to tracks_path, notice: 'Position was successfully created.' }
        format.json { render json: @position, status: :created, location: @position }
      else
        format.html { render action: "new" }
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
end
