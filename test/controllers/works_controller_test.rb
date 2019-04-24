require "test_helper"

describe WorksController do
  describe "index" do
    it "can get index" do
      get works_path

      must_respond_with :success
    end
  end

  describe "new" do
    it "can get the new work page" do
      get new_work_path

      must_respond_with :success
    end
  end
end
