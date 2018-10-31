class DashboardController < ApplicationController
  def index
    if session[:username]
      @user = User.find_by(id: session[:user_id])
      @status = Status.find_by(user_id: session[:user_id])
    else
      redirect_to root_path
    end
  end

  def home
    redirect_to root_path
  end

  def landingPage
    
  end
end
