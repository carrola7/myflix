class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user
  def current_user
    session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def ensure_logged_in
    access_denied unless logged_in?
  end

  def access_denied
    flash[:warning] = "You are not authorized to do that"
    redirect_to login_path
  end
end
