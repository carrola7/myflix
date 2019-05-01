class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  
  before_create :generate_token

  validates :email, :name, presence: true
  validates :email, uniqueness: true

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end