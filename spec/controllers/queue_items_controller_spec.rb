require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video_1 = Fabricate(:video)
      video_2 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: alice, video: video_1)
      queue_item2 = Fabricate(:queue_item, user: alice, video: video_2)
      get :index
      (assigns(:queue_items)).should match_array([queue_item1, queue_item2])
    end
    it "redirects to the sign in page for unauthenticated users" do
      get :index
      response.should redirect_to(login_path)
    end
  end

  describe "POST create" do
    context "for authenticated users" do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before do
        session[:user_id] = alice.id
      end
      it "creates a new queue item" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, video: video)
        QueueItem.count.should eq(1)
      end
      it "increments the position for a second queue item" do
        video_2 = Fabricate(:video)
        post :create, queue_item: Fabricate.attributes_for(:queue_item, video: video)
        post :create, queue_item: Fabricate.attributes_for(:queue_item, video: video_2)
        QueueItem.last.position.should eq(2)
      end
        

      it "redirects to the my_queue page" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, video: video)
        response.should redirect_to my_queue_path
      end
    end

    context "for unauthenticated users" do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      it "redirects to the sign in page" do
        post :create, queue_item: Fabricate.attributes_for(:queue_item, video: video)
        response.should redirect_to(login_path)
      end
    end
  end
end