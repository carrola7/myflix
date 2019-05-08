class InvitationsController < ApplicationController
  before_filter :ensure_logged_in, only: [:new, :create]

  def new 
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user
    if(User.find_by(email: @invitation.email))
      flash[:warning] = "That email address already belongs to a registered user"
      redirect_to people_path
    elsif @invitation.save
      flash[:success] = "Your invitation has been sent"
      AppMailer.delay.send_invitation(@invitation)
      redirect_to people_path
    else
      flash.now[:warning] = "There was a problem with your inputs"
      render :new
    end
  end

  def show
    invite = Invitation.find_by(token: params[:id])
    @user = User.new(email: invite.email)
    render 'users/new'
  end
  
  private

  def invitation_params
    params.require(:invitation).permit(:name, :email, :message)
  end
end