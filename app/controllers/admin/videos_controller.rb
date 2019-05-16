class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have created a new video, #{@video.title} "
      redirect_to new_admin_videos_path
    else
      flash[:danger] = "There was a problem with your inputs"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit([:title, :description, :category_id, :large_cover, :small_cover ])
  end
end