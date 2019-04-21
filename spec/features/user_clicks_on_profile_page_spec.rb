require 'spec_helper'

feature 'User clicks on profile page' do
  scenario 'user\'s reviews and queue items are displayed' do
    bob = Fabricate(:user, password: "password")
    user_signs_in(bob)
    category = Fabricate(:category)
    some_video = Fabricate(:video, category: category)
    10.times do
      Fabricate(:review, video: some_video, user: bob)
      Fabricate(:queue_item, video: some_video, user: bob)
    end

    visit user_path(bob)
    expect(page).to have_content "#{bob.full_name}'s Reviews (10)"
    expect(page).to have_content "#{bob.full_name}'s video collections (10)"
    expect(page).to have_content "#{category.name}"
    expect(page).to have_content "#{some_video.title}"
  end
end