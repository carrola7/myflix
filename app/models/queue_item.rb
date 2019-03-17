class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :user_id, :video_id
  validates :position, numericality: { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    user_review && user_review.rating
  end

  def rating=(new_rating)
    if user_review
      user_review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end
  
  def category_name
    category.name
  end
  
  private

  def user_review
    @user_review ||= Review.where(user: user, video: video).first
  end
end