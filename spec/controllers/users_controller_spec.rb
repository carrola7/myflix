require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do

      get :new 

      expect(assigns(:user)).to be_truthy 
    end
  end
  
end