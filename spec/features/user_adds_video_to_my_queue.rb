require 'spec_helper'

feature 'User queues a video' do
  background do
    user_signs_in
  end
  
  scenario 'adds the video to my queue page' do
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    visit home_path
    find("a[@href='/videos/#{video.id}']").click
    find_link('+ My Queue').click
    expect(page).to have_content "My Queue"
    expect(page).to have_content video.title
    expect(page).to have_content video.category.name
  end

  scenario 'when it is already queued' do
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    visit home_path
    find("a[@href='/videos/#{video.id}']").click
    find_link('+ My Queue').click
    visit video_path(video)
    expect(page).to_not have_content '+ My Queue'
    expect(page).to have_content 'Watch Now'
  end
end