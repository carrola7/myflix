require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    it_behaves_like "requires_signed_in_user" do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
    end
    context "with authenticated users" do
      before { set_current_user }
      context "with valid input" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        it "redirects to the video show page" do
          response.should redirect_to(video)
        end          

        it "creates a review" do
          Review.count.should eq(1)
        end
        it "creates a review associated with the video" do
          Review.first.video.should eq(video)
        end
        it "creates a review associated with the signed in user" do
          Review.first.user.should eq(current_user)
        end
      end

      context "with invalid input" do
        it "does not create a review" do
          post :create, review: {rating: 4}, video_id: video.id
          Review.count.should eq(0)
        end
        it "renders the video/show template" do
          post :create, review: {rating: 4}, video_id: video.id
          response.should render_template('videos/show')
        end
        it "sets @video" do
          post :create, review: {rating: 4}, video_id: video.id
          (assigns :video).should eq(video)
        end
        it "sets @review" do
          post :create, review: {rating: 4}, video_id: video.id
          (assigns :review).should be_instance_of(Review)      
        end
      end
    end
  end
end