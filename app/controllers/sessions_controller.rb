class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are logged in"
      redirect_to home_path
    else
      flash[:danger] = "There was a problem with your username or password"
      redirect_to login_path
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = "You are signed out"
    redirect_to root_path
  end
end