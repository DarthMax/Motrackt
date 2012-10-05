class SessionController < ApplicationController

  skip_filter :require_login

  # POST /sessions
  def create
    # User#authenticate returns nil if the is no user or the password does not match
    user = User.authenticate( params[:user][:name], params[:user][:password] )

    if user.nil?
      # login failed
      render action: root_url, alert: "Wrong username or password"
    else
      # successful login
      session[:user] = user.id

      # save the ip and the timestamp into the user object
      user = current_user
      user.last_login = Time.now
      user.save

      redirect_to "/tracks/", notice: "Successfully logged in"
    end
  end

  # DELETE /sessions/1
  def destroy
    # close the session
    reset_session

    redirect_to root_url, notice: "Successfully logged out"
  end

end
