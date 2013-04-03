class HomeController < ApplicationController

  skip_filter :require_login
  def index

  end

end
