class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  def rating
    user_review = Review.where(user: user, video: video).first
    user_review && user_review.rating
  end

  def video_title
    video.title
  end

  def category_name
    category.name
  end

  def category
    video.category
  end
end