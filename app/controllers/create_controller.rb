class CreateController < ApplicationController
    def index
      if session[:username]
        @user = User.find_by(username: session[:username])
      else
        redirect_to root_path
      end
    end
  end