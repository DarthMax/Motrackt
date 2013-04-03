class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def require_login
    if session[:user].nil?
      user = User.authenticate(:access_token => params[:access_token]) if params[:access_token]

      if user
        session[:user] = user.id
        return true
      end

      if request.url == root_url
        redirect_to root_path

      else
        session[:before_login_url] = request.url

        respond_to do |format|
          format.html {redirect_to root_path, :alert => "Please log in to continue"}
          format.json {head :unauthorized}
        end
      end

      return false

    else
      return true
    end
  end

  def current_user
    User.find_by_id( session[:user] )
  end







end
