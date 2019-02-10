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
        post :create, video_id: video.id
        QueueItem.count.should eq(1)
      end
      it "increments the position for a second queue item" do
        video_2 = Fabricate(:video)
        post :create, video_id: video.id
        post :create, video_id: video_2.id
        QueueItem.last.position.should eq(2)
      end
      it "redirects to the my_queue page" do
        post :create, video_id: video.id
        response.should redirect_to my_queue_path
      end
      it "creates the queue item that is associated with the video" do
        post :create, video_id: video.id
        QueueItem.first.video.title.should eq(video.title)
      end
      it "creates the queue item that is associated with the signed in user" do
        post :create, video_id: video.id
        QueueItem.first.user.should eq(alice)
      end
      it "puts the video as the last one in the queue" do
        Fabricate(:queue_item, video: video, user: alice)
        south_park = Fabricate(:video)
        post :create, video_id: south_park.id
        south_park_queue_item = QueueItem.find_by(video_id: south_park.id, user_id: alice.id)
        south_park_queue_item.position.should eq(2)
      end
      it "does not add the video to the queue if the video is already in the queue" do
        Fabricate(:queue_item, video: video, user: alice)
        post :create, video_id: video.id
        alice.queue_items.count.should eq(1)
      end

    end

    context "for unauthenticated users" do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      it "redirects to the sign in page" do
        post :create, video: video
        response.should redirect_to(login_path)
      end
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user_id: alice.id, video_id: video.id, position: 1) }
    context "for authenticated users" do
      before do
        session[:user_id] = alice.id
      end
      it "redirects to the queue items page" do
        delete :destroy, id: queue_item.id
        response.should redirect_to(my_queue_path)
      end
      it "removes the queue item" do
        delete :destroy, id: queue_item.id
        QueueItem.count.should eq(0)
      end
      it "does not remove the queue item if the current user does not own the queue item" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        delete :destroy, id: queue_item.id
        QueueItem.count.should eq(1)
      end
      it "updates the postion of the remaining queue items" do
        video = Fabricate(:video)
        queue_item_1 = Fabricate(:queue_item, user_id: alice.id, video_id: video.id, position: 1)
        video_2 = Fabricate(:video)
        queue_item_2 = Fabricate(:queue_item, user_id: alice.id, video_id: video_2.id, position: 2)
        video_3 = Fabricate(:video)
        queue_item_3 = Fabricate(:queue_item, user_id: alice.id, video_id: video_2.id, position: 3)
        delete :destroy, id: queue_item_2.id
        alice.queue_items.order(:position).last.position.should eq(2)
      end
    end
    context "for unauthenticated users" do
      it "redirects to the sign in page" do
        delete :destroy, id: queue_item.id
        response.should redirect_to(login_path)
      end
      it "doesn't remove the queue item" do
        delete :destroy, id: queue_item.id
        QueueItem.count.should eq(1)
      end
    end
  end

  describe "PUT update_all" do
    let(:alice) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:video_2) { Fabricate(:video) }
    let(:video_3) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user_id: alice.id, video_id: video.id, position: 1) }
    let(:queue_item_2) { Fabricate(:queue_item, user_id: alice.id, video_id: video_2.id, position: 2) }
    let(:queue_item_3) { Fabricate(:queue_item, user_id: alice.id, video_id: video_3.id, position: 3) }

    context "with authenticated_user" do
      before do
        session[:user_id] = alice.id
      end
      it "redirects to my_queue" do
        put :update_all, queue_items: []
        response.should redirect_to(my_queue_path)
      end
      it "reorders the queue_items according to new inputs" do
        put :update_all, queue_items: [{ id: queue_item.id, position: 3 }, { id: queue_item_2.id, position: 1 }, { id: queue_item_3.id, position: 2 }]
        alice.queue_items.order(:position).should eq([queue_item_2, queue_item_3, queue_item])
      end
      it "reorders the queue_items according to new inputs if the inputs are not chronological" do   
        put :update_all, queue_items: [{ id: queue_item.id, position: 8 }, { id: queue_item_2.id, position: 2 }, { id: queue_item_3.id, position: 4 }]
        alice.queue_items.order(:position).should eq([queue_item_2, queue_item_3, queue_item])
      end
      it "reorders the queue_items according to new inputs and replaces position attribute with correct one" do 
        put :update_all, queue_items: [{ id: queue_item.id, position: 8 }, { id: queue_item_2.id, position: 2 }, { id: queue_item_3.id, position: 4 }]
        alice.queue_items.find(queue_item.id).position.should eq(3)
      end
    end
  end
end