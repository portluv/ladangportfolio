class UsersController < ApplicationController
  before_action :set_user, only: [:updateUser, :destroyUser]
  before_action :set_profile, only: [:updateProfile]

  # GET /users
  # GET /users.json
  def index
    if session[:username]
      @user = User.find_by(username: session[:username])
      if(@user.profile != nil)
        @profile = @user.profile
      else
        @profile = Profile.new
      end
    else
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def signIn
  end

  # GET /users/new
  def signUp
    @user = User.new
  end

  def createSession
    user = User.find_by(username: params[:session][:username], password: params[:session][:password])
    respond_to do |format|
      if user
          session[:user_id] = user.id
          session[:username] = user.username 
          format.html { redirect_to root_path, notice: 'Sign in was successful.' }
      else
          format.html { redirect_to signin_path, notice: 'Sign in was unsuccessful.' }
      end
    end
  end

  # POST /users
  # POST /users.json
  def createUser
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        user = User.find_by(username: @user.username, password: @user.password)
        session[:user_id] = user.id
        session[:username] = user.username 
        format.html { redirect_to root_path, notice: 'Sign up was successful.' }
      else
        format.html { render :signUp }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /profiles
  # POST /profiles.json
  def createProfile
      @profile = Profile.new(profile_params)
      @profile.user_id = session[:user_id]

      respond_to do |format|
        if @profile.save
          format.html { redirect_to profile_path, notice: 'Profile updated.' }
        else
          format.html { render :index }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def updateUser
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'User updated.' }
      else
        format.html { render :editProfile }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def updateProfile
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_path, notice: 'Profile updated.' }
      else
        format.html { render :index }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
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

  def destroySession
    reset_session
    redirect_to signin_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:user).permit(:username, :password)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
        params.require(:profile).permit(:fullname, :dateofbirth, :gender, :phone, :address, :nationality, :degree, :lifemotto, :id)
    end   
end
