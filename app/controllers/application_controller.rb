class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_user
  before_filter :require_admin

  helper :all
  helper_method :current_user_session, :current_user
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    #@current_user = current_user_session && current_user_session.record
    @current_user = current_user_session && current_user_session.user
  end

  def require_creator
    unless current_user && current_user.creator? == true
      flash[:notice] = "You must be an creator to access this page"
      redirect_to surveys_url
      return false
    end
  end
  def require_admin
    unless current_user && current_user.admin? == true
      flash[:notice] = "You must be an admin to access this page"
      redirect_to surveys_url
      return false
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to logout_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end

class NotAllQuestionsAnsweredError < StandardError; end
