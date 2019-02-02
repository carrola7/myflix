require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with valid input" do
      before do
        user = Fabricate(:user)
        @video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review, user_id: user.id, video_id: @video.id)
      end

      it "saves a review" do
        Review.count.should eq(1)
      end
      it "redirects to video page" do
        response.should redirect_to video_path(@video)
      end
    end
  end
end