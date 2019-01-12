class Video < ActiveRecord::Base
  has_many :reviews
  belongs_to :category

  validates_presence_of :title, :description
end