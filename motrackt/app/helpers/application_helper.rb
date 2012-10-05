module ApplicationHelper
  def current_user
    User.find_by_id( session[:user] )
  end
end
