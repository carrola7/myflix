class VideosController < ApplicationController
  before_action :ensure_logged_in

  def index
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find params[:id])
    @review = Review.new
    @review.user = current_user
    @review.video = @video
  end

  def search
    query = params[:search]
    @videos = Video.search_by_title(query)
  end
end