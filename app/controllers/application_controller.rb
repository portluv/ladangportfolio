class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_is_logged_in?
  LINKEDIN_CLIENT_ID="81yo33f7eiiwk7"
  LINKEDIN_CLIENT_SECRET="c4xNKojRrNWkkPiv"
  GITHUB_CLIENT_ID="2273c99059d50712271a"
  GITHUB_CLIENT_SECRET="ce82b072c3bb3b3b4c7f7c56d07991fd10640e82"
  
  protected
  def user_is_logged_in?
    !!session[:user_id]
  end
end
