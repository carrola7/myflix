class QueueItemsController < ApplicationController
  before_action :ensure_logged_in

  def index
    @queue_items = current_user.queue_items
  end
end