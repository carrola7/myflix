require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  let(:user) { Fabricate(:user) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.video_title.should eq(video.title)
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating.should eq("4")
    end

    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating.should eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.category_name.should eq(category.name)
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.category.should eq(category)
    end
  end
end