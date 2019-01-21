require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
        @some_video = Fabricate(:video)
      end
      it "sets the @video variable" do
        get :show, id: @some_video.id
  
        assigns(:video).should == @some_video
      end

      it "renders the show template" do
        get :show, id: @some_video.id

        response.should render_template :show
      end
    end
  end
end