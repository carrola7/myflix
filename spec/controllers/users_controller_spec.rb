require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new 
      (assigns :user).should be_instance_of User 
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "saves a new user" do
        User.count.should eq(1)
      end
      it "redirects to the sign in page" do
        response.should redirect_to login_path
      end
    end

    context "with invalid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user, password: "")
      end
      it "does not create the user" do
        User.first.should be_nil
      end
      it "renders the new template if the user doesn't save" do
  
        response.should render_template :new
      end
      it "sets @user" do
        (assigns :user).should be_instance_of User
      end
    end
  end
end