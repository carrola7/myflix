class RelationshipsController < ApplicationController
  before_action :ensure_logged_in, only: [:create, :destroy]
  def create
    user = User.find(params[:followed_id])
    current_user.follow user
    redirect_to people_path
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    redirect_to people_path
  end
end