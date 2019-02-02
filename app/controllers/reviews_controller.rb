class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:notice] = "Your review has been saved"
      redirect_to video_path(@review.video)
    end
  end

  def review_params
    params.require(:review).permit([:rating, :comment, :user_id, :video_id])
  end
end