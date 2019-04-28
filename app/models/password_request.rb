class PasswordRequest < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email

  before_create :generate_token

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end