class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_is_logged_in?
  # protected
  # def authorize
  #   unless User.find_by(id: session[:user_id])
  #     redirect_to signin_path
  #   end
  # end
  protected
  def user_is_logged_in?
    !!session[:user_id]
  end
end
