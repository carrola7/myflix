class PasswordRequestsController < ApplicationController
  def create
    user = User.find_by(email: password_request_params[:email])
    if user
      user.password_request && user.password_request.destroy
      request = PasswordRequest.new(password_request_params)
      request.user = user
      request.save
      AppMailer.send_password_request_link(request).deliver
    end
    redirect_to confirm_password_request_path
  end

  def show
    @request = PasswordRequest.find_by(token: params[:id])
    if @request && @request.created_at > 1.day.ago
      render :show
    else
      redirect_to invalid_token_path
    end
  end

  def update
    @request = PasswordRequest.find_by(token: params[:id])
    @user = @request.user
    new_password = params[:password]
    @user.password = new_password
    if @user.save
      @request.destroy
      flash[:success] = "Your password has been changed"
      redirect_to login_path
    else
      flash.now[:danger] = "There was a problem with your password"
      render :show
    end

  end

  def to_param
    token
  end

  private

  def password_request_params
    params.require(:password_request).permit(:email)
  end
end