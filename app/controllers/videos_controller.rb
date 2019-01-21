class VideosController < ApplicationController
  before_action :ensure_logged_in

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find params[:id]
  end

  def search
    query = params[:search]
    @videos = Video.search_by_title(query)
  end
end