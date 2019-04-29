require "test_helper"

describe Vote do
  before do
    @user = User.first
    @work = Work.first
    @vote = Vote.new(user_id: @user.id, work_id: @work.id)
  end

  describe "validations" do
    it "is valid when all fields are present" do
      result = @vote.valid?

      expect(result).must_equal true
    end

    it "rejects users voting on the same work more than once" do
      @vote.save

      duplicate_vote = Vote.new(user_id: @user.id, work_id: @work.id)
      result = duplicate_vote.valid?

      expect(result).must_equal false
      expect(duplicate_vote.errors.messages).must_include :user
    end
  end

  describe "relations" do
    it "has a user" do
      expect(@vote.user_id).must_equal @user.id
    end

    it "has a work" do
      expect(@vote.work_id).must_equal @work.id
    end
  end
end
