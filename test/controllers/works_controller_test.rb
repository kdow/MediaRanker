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

  describe "create" do
    it "creates a new work" do
      work_data = {
        work: {
          category: "book",
          title: "Company",
          creator: "Max Barry",
          publication_year: 2007,
          description: "From the outside, Zephyr is just another bland corporate monolith, but behind its glass doors business is far from usual: the sales reps use self help books as manuals, no one has seen the CEO, no one knows exactly what they are selling, and missing donuts are the cause of office intrigue.",
        },
      }

      expect {
        post works_path, params: work_data
      }.must_change "Work.count", +1

      must_respond_with :redirect
      must_redirect_to works_path

      check_flash

      work = Work.last
      expect(work.title).must_equal work_data[:work][:title]
    end

    it "sends back bad_request if no work data is sent" do
      work_data = {
        work: {
          title: "",
        },
      }
      expect(Work.new(work_data[:work])).wont_be :valid?

      expect {
        post works_path, params: work_data
      }.wont_change "Work.count"

      must_respond_with :bad_request

      check_flash(:error)
    end
  end
end