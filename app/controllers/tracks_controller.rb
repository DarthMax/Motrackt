class TracksController < ApplicationController
  # GET /tracks
  # GET /tracks.json

  def index
    @tracks = current_user.tracks

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @tracks }
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = current_user.tracks.includes(:positions).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
      format.gpx { render text: @track.as_gpx}
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = current_user.tracks.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = current_user.tracks.find(params[:id])
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = current_user.tracks.new(params[:track])

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = current_user.tracks.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = current_user.tracks.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  # GET /tracks/1/chart_data.json
  # Returns the data need to draw a tracks height/speed graph
  def chart_data
    @track=current_user.tracks.find(params[:id])
    respond_to do |format|
      format.json {render :json => @track.as_chart_data}
    end
  end

  # Post /tracks/merge
  # Merges the given tracks to one
  def merge
    p params
    tracks = current_user.tracks.find(params[:track_ids])

    if tracks.count < 2
      respond_to do |format|
        format.html { redirect_to tracks_url, :alert => "Please select at least 2 tracks to merge!" }
      end
    end

    if @track=Track.merge(tracks)
      respond_to do |format|
        format.html { redirect_to track_url(@track), :notice => "Tracks merged successfully" }
      end
    else
      respond_to do |format|
        format.html { redirect_to tracks_url, :alert => "Could not merge tracks!" }
      end
    end
  end
end
