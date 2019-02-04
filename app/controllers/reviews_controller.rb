class ReviewsController < ApplicationController
  before_filter :ensure_logged_in
  # def create
  #   @review = Review.new(review_params)

  #   if @review.save
  #     flash[:success] = "Your review has been saved"
  #     redirect_to video_path(@review.video)
  #   else
  #     @video = @review.video
  #     render 'videos/show'
  #   end
  # end

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params.merge!(user: current_user))

    if @review.save
      flash[:success] = "Your review has been saved"
      redirect_to @video
    else
      @video = @review.video.reload
      render 'videos/show'
    end

  end

  def review_params
    params.require(:review).permit([:rating, :comment])
  end
end