class QueueItemsController < ApplicationController
  before_action :ensure_logged_in

  def index
    @queue_items = current_user.queue_items.order(:position)
  end

  def create
    @queue_item = QueueItem.new(queue_item_params.merge!(user: current_user, position: next_postition))
    if @queue_item.save
      redirect_to my_queue_path
    end
  end

  def destroy
    remove_queue_item
    redirect_to my_queue_path
  end

  private

  def queue_item_params
    params.require(:queue_item).permit([:video_id])
  end

  def next_postition
    QueueItem.count + 1
  end

  def remove_queue_item
    queue_item = QueueItem.find_by(id: params[:id], user_id: current_user.id)
    queue_item && queue_item.destroy
  end
end