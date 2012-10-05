class UsersController < ApplicationController
  # GET /users/1
  # GET /users/1.json
  def show
    @tracks=current_user.tracks.all :limit => 10
    @vehicles=current_user.vehicles

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
end
