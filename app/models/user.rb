class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items

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

end