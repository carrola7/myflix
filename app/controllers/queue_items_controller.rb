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
    queue_item = QueueItem.find_by(id: params[:id], user_id: current_user.id)
    if queue_item
      queue_item.destroy
      update_positions_by_position
    end
    redirect_to my_queue_path
  end

  def update_all
    #binding.pry
    QueueItem.transaction do
      update_positions_from_params
      raise ActiveRecord::Rollback if duplicate_positions?
      update_positions_by_position
    end
    
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

  def update_remaining_positions
    QueueItem.where("position > ?", find_queue_position).each do |queue_item|
      queue_item.position = queue_item.position - 1
      queue_item.save
    end
  end

  def find_queue_position
    QueueItem.find_by(id: params[:id], user_id: current_user.id).position
  end

  def update_positions_by_position
    current_user.queue_items.order(:position).each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def update_positions_from_params
    params[:queue_items].each do |queue_item_params|
      queue_item = QueueItem.find(queue_item_params[:id])
      queue_item.update(position: queue_item_params[:position]) if queue_item.user == current_user
    end
  end

  def duplicate_positions?
    current_user.queue_items.map(&:position).uniq.size != QueueItem.count
  end
end