require 'spec_helper'

describe VideosController do
  describe "GET show" do
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

    context "with unauthenticated users" do
      before do
        session.delete(:user_id)
        @some_video = Fabricate(:video)
      end

      it "redirects to login page" do
        get :show, id: @some_video.id
        response.should redirect_to login_path         
      end
    end
  end

  describe "GET search" do
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
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