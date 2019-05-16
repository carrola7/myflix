class ApplicationController < ActionController::Base
  #before_filter :set_raven_context

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

  private

  def set_raven_context
    Raven.user_context(id: session[:user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
