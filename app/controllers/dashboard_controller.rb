class DashboardController < ApplicationController
  def index
    if session[:username]
      @user = User.find_by(username: session[:username])
    else
      
    end
  end
end
