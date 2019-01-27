require 'spec_helper'

describe Video do
  it {should belong_to(:category)}
  it {should have_many(:reviews)}
  it {should validate_presence_of(:title)}
  it {is_expected.to validate_presence_of(:description)}

  describe "search by title" do
    it "returns an empty array if there is no match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_the_future  = Video.create(title: "Back to the Future", description: "Time Travel")
      expect(Video.search_by_title("hello")).to eq([])
    end
  
    it "returns an array of one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_the_future  = Video.create(title: "Back to the Future", description: "Time Travel")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end
  
    it "returns an array of one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_the_future  = Video.create(title: "Back to the Future", description: "Time Travel")
      expect(Video.search_by_title("urama")).to eq ([futurama])
    end 
  
    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      back_to_the_future  = Video.create(title: "Back to the Future", description: "Time Travel")
      expect(Video.search_by_title("Futur")).to eq([back_to_the_future, futurama])
    end

    it "returns a case-insensitive match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      expect(Video.search_by_title("futurama")).to eq([futurama])
    end

    it "returns an empty array for an empty string" do
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      back_to_the_future  = Video.create(title: "Back to the Future", description: "Time Travel")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
