class ConnectionController < ApplicationController
  before_action :set_user, only: [:addFriend]

    def index
        if session[:username]
          @user = User.find_by(id: session[:user_id])
          @users = User.all
          @friendship = Friendship.where('user_id = ? or friend = ?', session[:user_id], session[:user_id])
        else
          redirect_to root_path
        end
    end

    def addFriend
      @friendship = Friendship.new
      @friendship.user_id = session[:user_id]
      @friendship.friend = @user.id
      @friendship.status = 1

      respond_to do |format|
        if @friendship.save
          format.html { redirect_to connect_path, notice: 'Connection added.' }
        else
          format.html { render :index }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    end

    def removeFriend
      @friendship = Friendship.where('user_id = ? and friend = ? or user_id = ? and friend = ?', session[:user_id], params[:id], params[:id], session[:user_id]).first
      @friendship.destroy
      respond_to do |format|
        format.html { redirect_to connect_path, notice: 'Friendship was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end
      
end
