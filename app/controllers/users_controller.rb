class UsersController < ApplicationController
  before_filter :ensure_logged_in, only: [:show]
  def new
    @user = User.new
  end

  def create
    binding.pry
    @user = User.new(user_params)

    if @user.save
      Stripe::Charge.create({
        amount: 999,
        currency: 'eur',
        source: params[:stripeToken],
        description: "Charge for #{@user.email}",
      })
      AppMailer.notify_on_signup(@user).deliver
      flash[:success] = "Welcome to MyFliX"
      session[:user_id] = @user.id
      redirect_to login_path
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