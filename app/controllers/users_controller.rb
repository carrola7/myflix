class UsersController < ApplicationController
  before_filter :ensure_logged_in, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      charge = StripeWrapper::Charge.create({
        amount: 999,
        source: params[:stripeToken],
        description: "Charge for #{@user.email}",
      })
      if charge.successful?
        @user.save
        AppMailer.notify_on_signup(@user).deliver
        flash[:success] = "Welcome to MyFliX"
        session[:user_id] = @user.id
        redirect_to login_path
      else
      flash.now[:danger] = charge.error_message
      render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find params[:id]
  end

  private

  def user_params
    params.require(:user).permit([:email, :password, :full_name])
  end
end