class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    user_review = Review.where(user: user, video: video).first
    user_review && user_review.rating
  end

  def category_name
    category.name
  end
end