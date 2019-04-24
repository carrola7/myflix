require 'spec_helper'

feature 'user follows and unfollows another user' do
  scenario 'user follows another user' do
    bob = Fabricate(:user, password: "password")
    alice = Fabricate(:user)
    some_category = Fabricate(:category)
    futurama = Fabricate(:video, category: some_category)
    Fabricate(:review, user: alice, video: futurama)

    user_signs_in(bob)
    click_link('Videos')
    find("a[@href='/videos/#{futurama.id}']").click
    click_link("#{alice.full_name}")
    find('input[value="Follow"]').click
    expect(Relationship.count).to eq(1)
    click_link('People')
    expect(page).to have_content("#{alice.full_name}")
  end

  scenario 'user unfollows a user' do
    bob = Fabricate(:user, password: "password")
    alice = Fabricate(:user)
    some_category = Fabricate(:category)
    futurama = Fabricate(:video, category: some_category)
    Fabricate(:review, user: alice, video: futurama)
    relationship = Fabricate(:relationship, follower: bob, followed: alice)
    
    user_signs_in(bob)
    click_link('People')
    expect(page).to have_content("#{alice.full_name}")
    find("a[@href='/relationships/#{alice.id}']").click
    expect(page).to_not have_content("#{alice.full_name}")
    expect(Relationship.count).to eq(0)
  end
end