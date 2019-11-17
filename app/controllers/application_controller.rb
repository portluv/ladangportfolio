class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_is_logged_in?
  LINKEDIN_CLIENT_ID="81yo33f7eiiwk7"
  LINKEDIN_CLIENT_SECRET="c4xNKojRrNWkkPiv"
  
  protected
  def user_is_logged_in?
    !!session[:user_id]
  end
end
