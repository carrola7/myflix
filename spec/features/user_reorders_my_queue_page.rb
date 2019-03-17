require 'spec_helper'

feature 'the my_queue page' do
  background do
    user_signs_in
    category = Fabricate(:category)
    4.times do |num|
      Fabricate(:video, title: "video_#{ num + 1 }", category: category)
    end
    Video.all.sort_by(&:title).each_with_index do |video, index|
      Fabricate(:queue_item, video: video, user: bob, position: index + 1)
    end
  end

  scenario "reorders the videos when I enter new position numbers" do
    visit my_queue_path
    QueueItem.all.sort_by(&:position).each_with_index do |queue_item, index|
      fill_in("queue_items[][position]", with: "#{4 - index}", id: "queue_item_position_#{queue_item.id}")
    end
    expect(all('tr')[1]).to have_content("video_1")
    click_button "Update Instant Queue"
    expect(all('tr')[1]).to have_content("video_4")
  end
end