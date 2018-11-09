class ConnectionController < ApplicationController
    def index
        if session[:username]
          @user = User.find_by(id: session[:user_id])
          @users = User.all
        else
          redirect_to root_path
        end
    end
end
