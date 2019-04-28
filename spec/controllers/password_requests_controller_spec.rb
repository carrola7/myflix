require 'spec_helper'

describe PasswordRequestsController do
  describe "POST create" do
    context "with valid email address" do
      let(:bob) { Fabricate(:user) }
      context "when user already has a password request" do
        it "destroys the previous password request" do
          2.times do
            password_request = Fabricate.attributes_for(:password_request, email: bob.email, user: bob)
            post :create, password_request: password_request
          end
          expect(PasswordRequest.count).to eq(1)
        end
      end
      it "should redirect to the confirmation email send page" do
        post :create, password_request: Fabricate.attributes_for(:password_request) 
        expect(response).to redirect_to confirm_password_request_path
      end
      it "should create a new Password Request" do
        password_request = Fabricate.attributes_for(:password_request, email: bob.email)
        post :create, password_request: password_request 
        expect(PasswordRequest.count).to eq(1)
      end
      it "should create a new Password Request associated with the user" do
        password_request = Fabricate.attributes_for(:password_request, email: bob.email)
        post :create, password_request: password_request 
        expect(bob.password_request).to eq(PasswordRequest.first)
      end
      context "email sending" do
        after { ActionMailer::Base.deliveries.clear }
        before do
          password_request = Fabricate.attributes_for(:password_request, email: bob.email)
          post :create, password_request: password_request
        end
        it "sends an email" do 
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end
        it "sends an email to the correct address" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([bob.email])
        end
        it "sends an email with the correct link" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(PasswordRequest.first.token)
        end
      end
    end
    context "with invalid email address" do
      after { ActionMailer::Base.deliveries.clear }
      it "should redirect to the confirmation email send page" do
        post :create, password_request: Fabricate.attributes_for(:password_request) 
        expect(response).to redirect_to confirm_password_request_path
      end
      it "should not create a new password request" do
        password_request = Fabricate.attributes_for(:password_request)
        post :create, password_request: password_request 
        expect(PasswordRequest.count).to eq(0)
      end
      it "should not send an email" do
        password_request = Fabricate.attributes_for(:password_request)
        post :create, password_request: password_request 
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    context "valid token" do
      it "renders the change password page" do
        bob = Fabricate(:user)
        Fabricate(:password_request, email: bob.email)
        get :show, id: PasswordRequest.first.token
        expect(response).to render_template(:show)
      end
    end
    context "invalid token" do
      it "redirects to the invalid token page if the token is not real" do
        get :show, id: 'foo'
        expect(response).to redirect_to invalid_token_path
      end
      it "redirects to the invalid token page if the token has expired" do
        Fabricate(:password_request, created_at: 2.days.ago)
        get :show, id: PasswordRequest.first.token
        expect(response).to redirect_to invalid_token_path
      end
    end
  end

  describe "PUT update" do
    context "with valid password" do
      it "redirects to the sign in page" do
        bob = Fabricate(:user)
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "new_password"
        expect(response).to redirect_to login_path
      end
      it "displays a flash message" do
        bob = Fabricate(:user)
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "new_password"
        expect(flash[:success]).to be_present
      end
      it "updates the user's password" do
        bob = Fabricate(:user, password: "password")
        bob_password = bob.password
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "new_password"
        expect(User.first.authenticate("new_password")).to eq(bob)
      end
      it "destroys the password request" do
        bob = Fabricate(:user, password: "password")
        bob_password = bob.password
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "new_password"
        expect(PasswordRequest.count).to eq(0)
      end
    end
    context "with invalid password" do
      it "renders the reset password page" do
        bob = Fabricate(:user, password: "password")
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "foo"
        expect(response).to render_template(:show)
      end
      it "shows a flash message" do
        bob = Fabricate(:user, password: "password")
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "foo"
        expect(flash.now[:danger]).to be_present
      end
      it "does not save the password" do
        bob = Fabricate(:user, password: "password")
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "foo"
        expect(bob.reload.authenticate('foo')).to be_false
      end
      it "does not delete the password request" do
        bob = Fabricate(:user, password: "password")
        Fabricate(:password_request, user: bob)
        put :update, id: PasswordRequest.first.token, password: "foo"
        expect(PasswordRequest.count).to eq(1)
      end
    end
  end
end