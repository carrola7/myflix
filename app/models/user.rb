class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :relationships, source: :followed

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}
  validates :full_name, presence: true

  def normalize_queue_item_positions
    queue_items.order(:position).each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def review_for(video)
    reviews.find_by(video_id: video.id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end
end