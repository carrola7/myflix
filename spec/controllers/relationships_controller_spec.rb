require 'spec_helper'

describe RelationshipsController do
  describe "POST new" do
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
      expect(response).to redirect_to(user_path(alice))
    end
  end

  describe "DELETE destroy" do
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

    it "redirects to the user path" do
      delete :destroy, id: alice.id
      expect(response).to redirect_to(user_path(alice))
    end
  end
end