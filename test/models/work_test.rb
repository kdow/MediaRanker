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
  end

  describe "get_top_ten" do
    it "returns an array of up to 10 Work objects" do
      top_ten = Work.get_top_ten("book")
      expect(top_ten).must_be_instance_of Array
      expect(top_ten.first).must_be_instance_of Work
      expect(top_ten.length).must_be :<=, 10
    end
  end
end
