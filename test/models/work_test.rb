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
      user = users(:kelly)
      work = works(:lexicon)
      Vote.create!(work: work, user: user)
      new_votes_total = Work.all.sum { |work| work.votes.count }
      expect(new_votes_total).must_equal 1
      spotlight = Work.get_spotlight
      expect(spotlight).must_equal work
      expect(spotlight.votes.count).must_equal 1
    end

    it "returns the first work created in the case of a tie" do
      user = users(:kelly)
      work1 = works(:lexicon)
      work2 = works(:amelie)
      Vote.create!(work: work1, user: user)
      Vote.create!(work: work2, user: user)

      spotlight = Work.get_spotlight

      expect(spotlight).must_equal work1
    end

    it "returns the first work created if all works have no votes" do
      work1 = works(:lexicon)
      work2 = works(:amelie)
      work3 = works(:annihilation)

      spotlight = Work.get_spotlight

      expect(spotlight).must_equal work1
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

  describe "sorted_works" do
    it "returns a Works collection sorted in descending order by votes" do
      work1 = works(:amelie)
      work2 = works(:annihilation)
      user1 = users(:kelly)
      user2 = users(:jazzy)
      vote1 = Vote.create!(work_id: work1.id, user_id: user1.id)
      vote2 = Vote.create!(work_id: work1.id, user_id: user2.id)
      vote3 = Vote.create!(work_id: work2.id, user_id: user1.id)

      works = Work.sorted_works("movie")

      expect(works.first).must_be_instance_of Work
      expect(works.first).must_equal work1
      expect(works.last).must_equal work2
    end
  end
end
