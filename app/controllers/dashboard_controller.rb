class DashboardController < ApplicationController
  def index
    if session[:username]
      @user = User.find_by(id: session[:user_id])
      linkedinProfile = LinkedinProfile.find_by(user_id: session[:user_id])
      if linkedinProfile != nil
        if !linkedinProfile.confirmed_profiles
          redirect_to updateUserSignInWithLinkedIn_path
        end
      end
      @userStatus = Status.where(:user_id => session[:user_id]).order('id desc')
      @status = Status.new
    else
      redirect_to root_path
    end
  end

  def home
    redirect_to root_path
  end

  def landingPage
    
  end

  def newStatus
    @status = Status.new(status_params)
    @status.user_id = session[:user_id]
    @status.status_type = 1

    if @status.status != ""
      respond_to do |format|
        if @status.save
          format.html { redirect_to dashboard_path, notice: 'Status updated.' }
        else
          format.html { render :index }
          format.json { render json: @status.errors, status: :unprocessable_entity }
        end
      end
    else 
      redirect_to dashboard_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
        params.require(:status).permit(:status, :thing_id, :user_id)
    end  
end
