class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_one :password_request
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_invitations, class_name: 'Invitation', foreign_key: 'receiver_id', dependent: :destroy
  has_many :inviters, through: :received_invitations, source: :sender
  has_many :invitees, through: :sent_invitations, source: :receiver


  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}
  validates :full_name, presence: true

  after_create :fulfill_invitation

  def normalize_queue_item_positions
    queue_items.order(:position).each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def review_for(video)
    reviews.find_by(video_id: video.id)
  end

  def follow(other_user)
    self.following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  def admin?
    !!self.admin
  end

  private

  def fulfill_invitation
    invite = Invitation.find_by(email: email)
    if invite
      follow(invite.sender)
      invite.sender.follow(self)
      invite.destroy
    end
  end
end