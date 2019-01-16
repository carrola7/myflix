require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "returns an empty array if there are no videos" do
      category = Category.create(name: "Drama")
      expect(category.recent_videos).to eq([])
    end

    it "returns all videos if there are less than six" do
      category = Category.create(name: "Drama")
      movie1 = Video.create(title: "Movie1", description: "some movie", category: category, created_at: 1.day.ago)
      movie2 = Video.create(title: "Movie2", description: "some movie", category: category)
      expect(category.recent_videos).to eq([movie2, movie1])
    end

    it "returns six videos if there are exactly six" do
      category = Category.create(name: "Drama")
      6.times {Video.create(title: "Movie", description: "some movie", category: category)}
      expect(category.recent_videos.size).to eq(6)
    end

    it "returns six videos if there are more than six" do
      category = Category.create(name: "Drama")
      7.times {Video.create(title: "Movie", description: "some movie", category: category)}
      expect(category.recent_videos.size).to eq(6)
    end
    it "returns videos in chronological order" do
      category = Category.create(name: "Drama")
      
      movie1 = Video.create(title: "Movie1", description: "some movie", category: category, created_at: 4.days.ago)
      movie2 = Video.create(title: "Movie2", description: "some movie", category: category, created_at: 1.day.ago)
      movie3 = Video.create(title: "Movie3", description: "some movie", category: category, created_at: 7.days.ago)
      movie4 = Video.create(title: "Movie4", description: "some movie", category: category, created_at: 6.days.ago)
      movie5 = Video.create(title: "Movie5", description: "some movie", category: category, created_at: 5.days.ago)
      movie6 = Video.create(title: "Movie6", description: "some movie", category: category, created_at: 2.days.ago)
      movie7 = Video.create(title: "Movie7", description: "some movie", category: category, created_at: 3.days.ago)
      expect(category.recent_videos).to eq([movie2, movie6, movie7, movie1, movie5, movie4])
    end
  end
end