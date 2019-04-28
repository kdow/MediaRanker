require "test_helper"

describe Work do
  describe "validations" do
    before do
      @work = Work.new(category: "book", title: "test work", creator: "creator", publication_year: 2015, description: "book description")
    end

    it "is valid when all fields are present" do
      result = @work.valid?

      expect(result).must_equal true
    end

    it "is invalid without a title" do
      @work.title = nil

      result = @work.valid?

      expect(result).must_equal false
    end
  end

  describe "get_spotlight" do
    it "returns a Work object" do
      spotlight = Work.get_spotlight
      expect(spotlight).must_be_instance_of Work
    end

    it "returns the work with the most votes" do
      votes_total = Work.all.sum { |work| work.votes.count }
      expect(votes_total).must_equal 0
      user = User.first
      work = Work.create!(title: "test work")
      Vote.create!(work: work, user: user)
      new_votes_total = Work.all.sum { |work| work.votes.count }
      expect(new_votes_total).must_equal 1
      spotlight = Work.get_spotlight
      expect(spotlight).must_equal work
      expect(spotlight.votes.count).must_equal 1
    end

    it "returns nil if there are no works" do
      Work.destroy_all
      expect(Work.get_spotlight).must_be_nil
    end
  end

  describe "get_top_ten" do
    before do
      @top_ten = Work.get_top_ten("book")
    end
    it "returns an array of Work objects" do
      expect(@top_ten).must_be_instance_of Array
      expect(@top_ten.first).must_be_instance_of Work
    end

    it "works if there are less than 10 works" do
      expect(@top_ten.length).must_be :<, 10
    end

    it "returns an array of 10 Work objects if there are more than 10 works" do
      11.times do
        Work.create(category: "album", title: "test")
      end
      expect(Work.where(category: "album").length).must_be :>, 10
      expect(Work.get_top_ten("album").length).must_equal 10
    end

    it "returns an empty array if there are no works" do
      Work.destroy_all
      expect(Work.get_top_ten("movie")).must_be_empty
    end
  end
end
