require 'spec_helper'

# describe ReviewsController do
#   describe "POST create" do
#     context "with valid input" do
#       before do
#         user = Fabricate(:user)
#         @video = Fabricate(:video)
#         post :create, review: Fabricate.attributes_for(:review, user_id: user.id, video_id: @video.id)
#       end

#       it "saves a review" do
#         Review.count.should eq(1)
#       end
#       it "redirects to video page" do
#         response.should redirect_to video_path(@video)
#       end
#     end

#     context "with invalid input" do
#       before do
#         @user = Fabricate(:user)
#         @video = Fabricate(:video)
#       end

#       it "sets the @video variable" do
#         post :create, review: Fabricate.attributes_for(:review, comment: nil, user_id: @user.id, video_id: @video.id)
#         (assigns :video).should be_instance_of Video
#       end

#       it "renders the show video page" do
#         post :create, review: Fabricate.attributes_for(:review, comment: nil, user_id: @user.id, video_id: @video.id)
#         response.should render_template "videos/show"
#       end
#     end

#     context "with invalid unauthorised user" do
#       before do
#         @video = Fabricate(:video)
#       end
#     end
#   end
# end

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id}
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
    context "with unauthenticated users" do
      it "redirects to the sign in path" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        response.should redirect_to root_path
      end
    end
  end
end