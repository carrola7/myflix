require 'spec_helper'

feature 'Admin adds a video' do
  scenario 'video is viewable by user' do
    admin_signs_in
    Fabricate(:category, name: 'Comedy')
    visit new_admin_videos_path
    fill_in_video_form
    visit sign_out_path

    user_signs_in
    visit home_path

    find("a[@href='/videos/#{Video.first.id}']").click
    save_and_open_page
    expect(page).to have_link(nil, href: 'https://s3-eu-west-1.amazonaws.com/myflix-storage/HW3+watch+video.mp4')
  end
end

def fill_in_video_form
  fill_in 'Title', with: 'Test Video'
  select 'Comedy', from: 'Category'
  fill_in 'Description', with: 'Video Description'
  attach_file("Large Cover", Rails.root + "public/tmp/monk_large.jpg")
  attach_file("Small Cover", Rails.root + "public/tmp/monk.jpg")
  fill_in 'Video URL', with: 'https://s3-eu-west-1.amazonaws.com/myflix-storage/HW3+watch+video.mp4'
  click_button 'Add a Video'
end