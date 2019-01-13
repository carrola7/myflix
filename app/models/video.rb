class Video < ActiveRecord::Base
  has_many :reviews
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(query)
    return [] if query.blank?
    Video.where("lower(title) LIKE ?", "%#{query.downcase}%").order("created_at DESC")
  end
end