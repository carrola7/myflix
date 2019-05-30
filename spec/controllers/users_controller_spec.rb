require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new 
      (assigns :user).should be_instance_of User 
    end
  end

  describe "POST create" do
    context "with valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true)}
      before { expect(StripeWrapper::Charge).to receive(:create).and_return(charge) }
      it "saves a new user" do
        post :create, user: Fabricate.attributes_for(:user)
        User.count.should eq(1)
      end
      it "redirects to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        response.should redirect_to login_path
      end
      it "follows another user if invited to join" do
        bob = Fabricate(:user)
        alice = Fabricate.attributes_for(:user)
        Fabricate(:invitation, sender: bob, email: alice[:email])
        post :create, user: alice
        alice = User.find_by(email: alice[:email])
        expect(alice.following?(bob)).to be_true
      end
      it "is followed by another user if invited to join" do
        bob = Fabricate(:user)
        alice = Fabricate.attributes_for(:user)
        Fabricate(:invitation, sender: bob, email: alice[:email])
        post :create, user: alice
        alice = User.find_by(email: alice[:email])
        expect(bob.following?(alice)).to be_true
      end
      it "expires the invitation on fulfillment" do
        bob = Fabricate(:user)
        alice = Fabricate.attributes_for(:user)
        Fabricate(:invitation, sender: bob, email: alice[:email])
        post :create, user: alice
        alice = User.find_by(email: alice[:email])
        expect(Invitation.count).to eq(0)
      end
    end

    context 'valid personal info and declined card' do
      it 'does not create a new user record' do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(User.count).to eq(0)
      end
      it 'renders the new template' do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(response).to render_template(:new)
      end
      it 'sets the flash error message' do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '12345'
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid personal info" do
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
      it 'does not charge the card' do
        expect(StripeWrapper::Charge).to_not receive(:create)
        post :create,  user: { email: 'joe@example.com' }
      end
    end

    context "email sending" do
      let(:charge) { double(:charge, successful?: true)}
      before { expect(StripeWrapper::Charge).to receive(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }
      it "sends out the email" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      it "sends to the right recipient" do
        alice = Fabricate.attributes_for(:user)
        post :create, user: alice
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([alice[:email]])
      end
      it "has the right content" do
        post :create, user: Fabricate.attributes_for(:user)
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Hi #{User.first.full_name}")
      end
    end
  end

  describe "GET show" do
    it_behaves_like 'requires_signed_in_user' do
      let(:action) { get :show, id: 3 }
    end
  
    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end