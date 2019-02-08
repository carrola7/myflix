class QueueItemsController < ApplicationController
  before_action :ensure_logged_in

  def index
    @queue_items = current_user.queue_items.order(:position)
  end

  def create
    video = Video.find(params[:video_id])
    add_to_queue(video)  
    redirect_to my_queue_path
  end

  def destroy
    remove_queue_item
    redirect_to my_queue_path
  end

  private

  def add_to_queue(video)
    QueueItem.create(video: video, user: current_user, position: next_postition) unless already_queued?(video)
  end

  def next_postition
    current_user.queue_items.count + 1
  end

  def already_queued?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def remove_queue_item
    queue_item = QueueItem.find_by(id: params[:id], user_id: current_user.id)
    queue_item && queue_item.destroy
  end
end