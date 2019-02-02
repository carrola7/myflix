class Video < ActiveRecord::Base
  has_many :reviews
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(query)
    return [] if query.blank?
    Video.where("lower(title) LIKE ?", "%#{query.downcase}%").order("created_at DESC")
  end

  def rating
    ratings = reviews.map(&:rating).map(&:to_i)
    (ratings.reduce(&:+).to_f / ratings.size).round(1)
  end
end