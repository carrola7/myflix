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
      current_user.normalize_queue_item_positions
    end
    redirect_to my_queue_path
  end

  def update_all
    begin
      QueueItem.transaction do
        update_queue_items
        current_user.normalize_queue_item_positions
      end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid inputs"
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

  

  def update_queue_items
    params[:queue_items].each do |queue_item_params|
      queue_item = QueueItem.find(queue_item_params[:id])
      if queue_item.user == current_user
        review = current_user.review_for queue_item.video
        if review
          review.update_attributes!(rating: queue_item_params[:rating])
        elsif queue_item_params[:rating] != ""
          Review.create(rating: queue_item_params[:rating], comment: "No comment added", user: current_user, video: queue_item.video)
        end
        queue_item.update_attributes!(position: queue_item_params[:position])
      end
    end
  end

  def duplicate_positions?
    current_user.queue_items.map(&:position).uniq.size != QueueItem.count
  end
end