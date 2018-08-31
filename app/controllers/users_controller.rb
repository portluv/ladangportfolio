class UsersController < ApplicationController
  before_action :set_user, only: [:editProfile, :updateProfile, :destroyUser]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def signIn
  end

  # GET /users/new
  def signUp
    @user = User.new
  end

  # GET /users/1/edit
  def editProfile
  end

  def createSession
    user = User.find_by(username: params[:session][:username], password: params[:session][:password])
    respond_to do |format|
      if user
          format.html { redirect_to root_path, notice: 'Sign in was successful.' }
      else
          format.html { redirect_to root_path, notice: 'Sign in was unsuccessful.' }
      end
    end
  end

  # POST /users
  # POST /users.json
  def createUser
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'Sign up was successful.' }
      else
        format.html { render :signUp }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def updateProfile
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'New profile saved.' }
      else
        format.html { render :editProfile }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroyUser
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:user).permit(:username, :password)
    end
end
