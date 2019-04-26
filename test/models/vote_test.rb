require "test_helper"

describe Vote do
  let(:vote) { Vote.new }

  it "must be valid" do
    value(vote).must_be :valid?
  end
end
