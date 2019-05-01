require 'spec_helper'

describe InvitationsController do
  describe "post CREATE" do
    context "with valid inputs" do
      let(:bob) { Fabricate(:user) }
        context "with an unregistered email" do
        let(:invite) { Fabricate.attributes_for(:invitation) }
        it_behaves_like "requires_signed_in_user" do
          let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
        end      
        before do
          set_current_user(bob)
        end
        it "shows a flash message" do
          post :create, invitation: invite
          expect(flash[:success]).to be_present
        end
        it "redirects to the people page" do
          post :create, invitation: invite
          expect(response).to redirect_to people_path
        end
        it "creates an invitation" do
          post :create, invitation: invite
          expect(Invitation.count).to eq(1)
        end
        it "creates an invitation associated with the current user" do
          post :create, invitation: invite
          expect(Invitation.first.sender).to eq(bob)
        end
        context "email sending" do
          after { ActionMailer::Base.deliveries.clear }
          before { post :create, invitation: invite }
          it "sends an email" do
            expect(ActionMailer::Base.deliveries).to_not be_empty
          end
          it "sends an email to the invited user" do
            message = ActionMailer::Base.deliveries.last
            expect(message.to).to include(Invitation.first.email)
          end
          it "sends an email with the correct link" do
            message = ActionMailer::Base.deliveries.last
            expect(message.body).to include(Invitation.first.token)
          end
        end
      end
      context "with an email that is already a registered user" do
        let(:alice) { Fabricate(:user) }
        let(:invite) { Fabricate.attributes_for(:invitation, email: alice.email) }
        before do
          set_current_user(bob)
          post :create, invitation: invite
        end
        after { ActionMailer::Base.deliveries.clear }
        it "shows an info message" do
          expect(flash[:warning]).to be_present
        end
        it "does not create an invitation" do
          expect(Invitation.count).to eq(0)
        end
        it "renders :new" do
          expect(response).to redirect_to people_path
        end
        context "email sending" do
          it "does not send out an email" do
            expect(ActionMailer::Base.deliveries).to be_empty
          end
        end
      end
      context "with an email that already has an invitation" do
        before do
          set_current_user(bob)
          alice = Fabricate.attributes_for(:user)
          joe = Fabricate(:user)
          Fabricate(:invitation, sender: joe, email: alice[:email])
          invite = Fabricate.attributes_for(:invitation, email: alice[:email])
          post :create, invitation: invite
        end
        it "does not create an invitation" do
          expect(Invitation.count).to eq(1)
        end
        it "shows a warning message" do
          expect(flash[:warning]).to be_present
        end
        it "renders :new" do
          expect(response).to render_template :new
        end
      end
    end
    context "with invalid inputs" do
      let(:bob) { Fabricate(:user) }
      let(:invite) { Fabricate.attributes_for(:invitation, email: nil) }
      before do
        set_current_user(bob)
        post :create, invitation: invite
      end
      it "shows an error message" do
        expect(flash.now[:warning]).to be_present
      end
      it "re-renders the page" do
        expect(response).to render_template :new
      end
      context "email sending" do
        it "does not send out an email" do
          expect(ActionMailer::Base.deliveries).to be_empty
        end
      end
    end
  end

  describe "GET show" do
    let(:bob) { Fabricate(:user) }
    let(:invite) { Fabricate(:invitation, email: 'joe@example.com') }
    before do
      get :show, id: invite.token
    end
    it "renders users_controller#new" do
      expect(response).to render_template 'users/new'
    end
    it "sets @user" do
      expect(assigns[:user]).to be_present
    end
    it "sets @user to be an instance of User" do
      expect(assigns[:user]).to be_instance_of User
    end
    it "sets @user's email to be the same as the invitations" do
      expect(assigns[:user].email).to eq('joe@example.com')
    end
  end
end