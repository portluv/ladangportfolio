class UsersController < ApplicationController
  before_action :set_user, only: [:destroyUser]
  before_action :set_profile, only: [:updateProfile]

  def index
    @user = User.find_by(id: params[:id])
    if(@user.profile != nil)
      @profile = @user.profile
      if(@profile.education != nil)
        @education = @profile.education
      else
        @education = Education.new
      end
      if(@profile.experience != nil)
        @experience = @profile.experience
      else
        @experience = Experience.new
      end
    else
      @profile = Profile.new
      @education = Education.new
      @experience = Experience.new
    end
  end

  def edit
    if session[:username]
      @user = User.find_by(username: session[:username])
      if(@user.profile != nil)
        @profile = @user.profile
        if(@profile.education != nil)
          @education = @profile.education
        else
          @education = Education.new
        end
        if(@profile.experience != nil)
          @experience = @profile.experience
        else
          @experience = Experience.new
        end
      else
        @profile = Profile.new
        @education = Education.new
        @experience = Experience.new
      end
    else
      redirect_to root_path
    end
  end

  def signIn
    if session[:user_id]
      redirect_to dashboard_path
    end
  end

  def signUp
    if session[:user_id]
      redirect_to dashboard_path
    end
    @user = User.new
  end

  def updateUserSignInWithLinkedIn
    @user = User.find_by(id: session[:user_id])
    @user.password=""
  end

  def createSession
    user = User.find_by(username: params[:session][:username], password: params[:session][:password])
    respond_to do |format|
      if user
          session[:user_id] = user.id
          session[:username] = user.username 
          format.html { redirect_to dashboard_path, notice: 'Sign in was successful.' }
      else
          format.html { redirect_to signin_path, notice: 'Sign in was unsuccessful.' }
      end
    end
  end

  def createUser
    @user = User.new(user_params)
    @status = Status.new
    @status.status_type = 2
    @status.status = " created an account"
    respond_to do |format|
      if @user.save
        user = User.find_by(username: @user.username, password: @user.password)
        session[:user_id] = user.id
        session[:username] = user.username 
        @status.user_id = session[:user_id]
        @status.save
        format.html { redirect_to dashboard_path, notice: 'Sign up was successful.' }
      else
        format.html { render :signUp }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def updateUser
    @user = User.find_by(id: session[:user_id])
    usedUsername=false
    usedEmail=false
    user = User.where(username: params[:username])
    if user.count > 1
      usedUsername=true
    end
    user = User.where(email: params[:email])
    if user.count > 1
      usedEmail=true
    end
    respond_to do |format|
      if !usedUsername && !usedEmail && @user.update(user_params)
        user = User.find_by(username: @user.username, password: @user.password)
        @linkedinProfile = LinkedinProfile.find_by(user_id: session[:user_id])
        @linkedinProfile.update(confirmed_profiles: true)
        session[:user_id] = user.id
        session[:username] = user.username 
        format.html { redirect_to dashboard_path, notice: 'Update user was successful.' }
      else
        if usedUsername
          @user.errors.add(:username, "Username already exist!")
        end
        if usedEmail
          @user.errors.add(:email, "Email is already used!")
        end
        format.html { render :updateUserSignInWithLinkedIn }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def linkedInAuthRedirect
    state_csrf = ('A'..'Z').to_a.shuffle[0,15].join
    redirect_uri=""
    if request.host=="localhost"
      redirect_uri=request.protocol + request.host_with_port
    else
      redirect_uri=request.protocol + request.host
    end

    redirect_uri+="/linkedIn/signin"
    link="https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id="+LINKEDIN_CLIENT_ID+"&redirect_uri="+redirect_uri+"&state="+state_csrf+"&scope=r_liteprofile%20r_emailaddress%20w_member_social"
    redirect_to link
  end

  def signInWithLinkedIn
    redirect_uri=""
    if request.host=="localhost"
      redirect_uri=request.protocol + request.host_with_port
    else
      redirect_uri=request.protocol + request.host
    end
    redirect_uri+=request.path
    
    params = {
      'grant_type' => 'authorization_code',
      'code' => request.GET["code"],
      'redirect_uri' => redirect_uri,
      'client_id' => LINKEDIN_CLIENT_ID,
      'client_secret' => LINKEDIN_CLIENT_SECRET,
    }
    res = HTTParty.post("https://www.linkedin.com/oauth/v2/accessToken",
      :body => params,
      :headers => {'Content-Type' => 'application/x-www-form-urlencoded'}
    )
    accessToken=res["access_token"]
    expireIn=Date.today
    expireIn+=res["expires_in"]/(60*60*24)

    res = HTTParty.get("https://api.linkedin.com/v2/me",
      :headers => {'Authorization' => 'Bearer '+accessToken}
    )
    fullname=res["localizedFirstName"]+" "+res["localizedLastName"]
    linkedInProfileID=res["id"]

    linkedin_login = LinkedinProfile.find_by(linkedin_profile_id: linkedInProfileID)
    if linkedin_login
        linkedin_login.update(access_token: accessToken, expire_in: expireIn)
        user = User.find_by(id: linkedin_login.user_id)
        session[:user_id] = user.id
        session[:username] = user.username 
        flash[:notice] = 'Sign in was successful.'
        redirect_to dashboard_path
    else
      res = HTTParty.get("https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))",
        :headers => {'Authorization' => 'Bearer '+accessToken}
      )
      email=res["elements"][0]["handle~"]["emailAddress"]
      username = email.slice(0..(email.index('@')-1))
      
      @user = User.new
      @user.username=username+"-"+linkedInProfileID
      @user.email=email
      @user.password= ('A'..'Z').to_a.shuffle[0,15].join
      @user.save
      user = User.find_by(username: @user.username, password: @user.password)
      session[:user_id] = user.id
      session[:username] = user.username 
  
      @status = Status.new
      @status.user_id = session[:user_id]
      @status.status_type = 2
      @status.status = " created an account"
      @status.save
  
      @profile = Profile.new
      @profile.fullname=fullname
      @profile.user_id=user.id
      @profile.save
  
      @linkedinProfile = LinkedinProfile.new
      @linkedinProfile.access_token = accessToken
      @linkedinProfile.expire_in = expireIn
      @linkedinProfile.linkedin_profile_id=linkedInProfileID
      @linkedinProfile.user_id=user.id
      @linkedinProfile.save
      
      respond_to do |format|
        if user
            session[:user_id] = user.id
            session[:username] = user.username 
            format.html { redirect_to dashboard_path, notice: 'Sign in was successful.' }
        else
            format.html { redirect_to signin_path, notice: 'Sign in was unsuccessful.' }
        end
      end
    end
  end

  def createProfile
      @profile = Profile.new(profile_params)
      @profile.user_id = session[:user_id]
      if params[:profile][:profile_picture].present?
        @profile.profile_picture = params[:profile][:profile_picture_link]
      end

      if params[:profile][:home_picture].present?
        @profile.home_picture = params[:profile][:home_picture_link]
      end
    
      if params[:profile][:education_attributes].present?
        params[:profile][:education_attributes].each do |index, param|
          param[:firm_id] = 1
          param[:profile_id] = @profile.id
          if param[:id] === "" and param[:degree] != ""
            createEducation(param)
          elsif param[:id] != ""
            education = Education.find_by(id: param[:id])
            updateEducation(education, param)
          end
        end
        @profile.education.each do |x|
          x.firm_id = 1
        end
      end

      respond_to do |format|
        if @profile.save
          format.html { redirect_to viewProfile_path(@profile), notice: 'Profile created.' }
        else
          format.html { redirect_to editProfile_path(@profile) }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
  end

  def updateProfile
    if params[:profile][:profile_picture].present?
      @profile.profile_picture = params[:profile][:profile_picture_link]
    end

    if params[:profile][:home_picture].present?
      @profile.home_picture = params[:profile][:home_picture_link]
    end
    
    if params[:profile][:education_attributes].present?
      params[:profile][:education_attributes].each do |index, param|
        param[:firm_id] = 1
        param[:profile_id] = @profile.id
      end
    end
    
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to editProfile_path, notice: 'Profile updated.' }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

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
  # To create education based on education data sent through param
    def createEducation(params)
      @education = Education.new
      @education.profile_id = params[:profile_id]
      @education.firm_id = params[:firm_id]
      @education.degree = params[:degree]
      @education.join_date = params[:join_date]
      @education.end_date = params[:end_date]
      @education.save
    end

    # To update education based on education model sent through param
    def updateEducation(education, params)
      @education = education
      @education.update(degree: params[:degree], join_date: params[:join_date], end_date: params[:end_date])
    end

    # To create experience based on experience data sent through param
    def createExperience(params)
      @experience = Experience.new
      @experience.profile_id = params[:profile_id]
      @experience.firm_id = params[:firm_id]
      @experience.position = params[:position]
      @experience.start_date = params[:start_date]
      @experience.end_date = params[:end_date]
      @experience.save
    end

    # To update experience based on experience model sent through param
    def updateExperience(experience, params)
      @experience = experience
      @experience.update(position: params[:position])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_education
      @education = Education.find(params[:id])
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
      params.require(:profile).permit(:fullname, :dateofbirth, :gender, :phone, :address, :nationality, :degree, :lifemotto, :summary, :id, education_attributes: [:degree, :join_date, :end_date, :profile_id, :firm_id, :id])
    end   
end
