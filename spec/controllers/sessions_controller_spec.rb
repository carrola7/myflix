require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    context "when user is not logged in" do
      it "renders the :new template" do
        get :new
        response.should render_template(:new)
      end
    end
  end

    context "when user is logged in" do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "redirects to home_path" do
        get :new
        response.should redirect_to(home_path)
      end
    end

  describe "POST create" do
    context "with valid credentials" do
      before do
        @user = Fabricate(:user)
        post :create, email: @user.email, password: @user.password
      end
      it "sets the session user_id to user's id" do
        (session[:user_id]).should == @user.id
      end 
      it "redirects to home path" do
        response.should redirect_to(home_path)
      end
      it "sets the message" do
        flash[:success].should == "You are logged in"
      end
    end

    context "with invalid credentials" do
      let(:alice) { Fabricate(:user) }
      it_behaves_like "requires_signed_in_user" do
        let(:action) { post :create, email: alice.email, password: alice.password + "a" }
      end
      it "sets the message" do
        post :create, email: alice.email, password: alice.password + "a"
        flash[:danger].should == "There was a problem with your username or password"
      end
    end
  end

  describe "GET destroy" do
    context "with valid user logged in" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
  
      end
      it "deletes the user_id from the session" do
        get :destroy
        session[:user_id].should be_nil
      end

      it "sets the flash message" do
        get :destroy
        flash[:success].should == "You are signed out"
      end
  
      it "redirects to root path" do
        get :destroy
        response.should redirect_to(root_path)
      end
    end
  end
end