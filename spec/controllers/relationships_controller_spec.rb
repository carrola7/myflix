require 'spec_helper'

describe RelationshipsController do
  describe "POST new" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { post :create, followed_id: Fabricate(:user).id }
    end
    let(:bob) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }
    before do
      set_current_user(bob)
      post :create, followed_id: alice.id
    end
    
    it "creates a new relationship" do
      expect(bob.following.first).to eq(alice)
    end
    it "redirects to the user path" do
      expect(response).to redirect_to(people_path)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { delete :destroy, id: Fabricate(:user).id }
    end

    let(:bob) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }

    before do
      set_current_user(bob)
      post :create, followed_id: alice.id
    end
    
    it "deletes the relationship" do
      expect(bob.following.first).to eq(alice)
      delete :destroy, id: alice.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the relationship does not belong to the current signed in user" do
      john = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, followed: john)
      delete :destroy, id: alice.id
      expect(Relationship.count).to eq(1)
    end

    it "redirects to the user path" do
      delete :destroy, id: alice.id
      expect(response).to redirect_to(people_path)
    end
  end
end