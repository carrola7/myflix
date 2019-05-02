class PasswordRequest < ActiveRecord::Base
  include Tokenable
  
  belongs_to :user
  validates_presence_of :email
end