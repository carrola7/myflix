require 'spec_helper'

describe User do
  it {should have_many(:reviews)}
  it {should have_many(:queue_items)}
  it {should validate_presence_of(:email)}
  it {should validate_uniqueness_of(:email)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:full_name)}
  it {should have_many(:sent_invitations)}
  it {should have_many(:received_invitations)}
  it {should have_many(:inviters)}
  it {should have_many(:invitees)}


  it "should follow and unfollow a user" do
    bob = Fabricate(:user)
    alice = Fabricate(:user)
    expect(bob.following?(alice)).to be_false
    bob.follow(alice)
    expect(bob.following?(alice)).to be_true
    bob.unfollow(alice)
    expect(bob.following?(alice)).to be_false
  end
end
