require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { get :show, id: Fabricate(:video).id }
    end
    context "with authenticated users" do
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

  describe "GET search" do
    context "with authenticated users" do
      before do
        set_current_user
        @futurama = Fabricate(:video, title: "Futurama")
      end
  
      it "sets the @video variable" do
        get :search, search: "rama"
  
        assigns(:videos).should == [@futurama]
      end

      it "renders the search template" do
        get :search, search: Video.first.title

        response.should render_template :search
      end
    end

    context "with unauthenticated users" do
      before do
        session[:user_id] = nil
        @futurama = Fabricate(:video, title: "Futurama")
      end

      it "redirects to login path" do
        get :search, search: "rama"

        response.should redirect_to login_path
      end
    end
  end
end