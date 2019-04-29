require "test_helper"

describe WorksController do
  before do
    @work = Work.create!(title: "Test title")
  end

  describe "index" do
    it "can get index" do
      get works_path

      must_respond_with :success
    end

    it "renders even if there are zero works" do
      Work.destroy_all

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
          description: "Office shenanigans",
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

  describe "show" do
    it "returns a 404 status code if the work doesn't exist" do
      work_id = 12345392487
      expect(Work.find_by(id: work_id)).must_be_nil

      get work_path(work_id)

      must_respond_with :not_found
    end

    it "functions for a work that exists" do
      get work_path(@work.id)

      must_respond_with :success
    end
  end

  describe "edit" do
    it "responds with OK for a real work" do
      get edit_work_path(@work)
      must_respond_with :ok
    end

    it "responds with NOT FOUND for a fake work" do
      work_id = Work.last.id + 1
      get edit_work_path(work_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    before do
      @work_data = {
        work: {
          title: "New title",
        },
      }
    end

    it "changes the data on the model" do
      @work.assign_attributes(@work_data[:work])
      expect(@work).must_be :valid?
      @work.reload

      patch work_path(@work), params: @work_data

      must_respond_with :redirect
      must_redirect_to work_path(@work)

      check_flash

      @work.reload
      expect(@work.title).must_equal(@work_data[:work][:title])
    end

    it "responds with NOT FOUND for a fake book" do
      work_id = Work.last.id + 1
      patch work_path(work_id), params: @work_data
      must_respond_with :not_found
    end

    it "responds with BAD REQUEST for bad data" do
      @work_data[:work][:title] = ""

      @work.assign_attributes(@work_data[:work])
      expect(@work).wont_be :valid?
      @work.reload

      patch work_path(@work), params: @work_data

      must_respond_with :bad_request

      check_flash(:error)
    end
  end

  describe "destroy" do
    it "removes the work from the database" do
      expect {
        delete work_path(@work)
      }.must_change "Work.count", -1

      must_respond_with :redirect
      must_redirect_to works_path

      check_flash

      after_work = Work.find_by(id: @work.id)
      expect(after_work).must_be_nil
    end

    it "returns a 404 if the work does not exist" do
      work_id = 123456

      expect(Work.find_by(id: work_id)).must_be_nil

      expect {
        delete work_path(work_id)
      }.wont_change "Work.count"

      must_respond_with :not_found
    end
  end

  describe "upvote" do
    it "disallows guest users voting if they have not logged in" do
      user = users(:kelly)
      work = works(:amelie)
      get upvote_path(work, user)

      expect {
        get upvote_path(work, user)
      }.wont_change "Vote.count"

      must_respond_with :redirect
      must_redirect_to login_path
    end

    it "allows a logged-in user to vote for a work they haven't already voted for" do
      user = perform_login
      work = works(:amelie)

      expect {
        get upvote_path(work, user)
      }.must_change "Vote.count", +1

      must_respond_with :redirect
      must_redirect_to work_path(work.id)
    end

    it "disallows a logged-in user to vote for a work they have previously voted for" do
      user = perform_login
      work = works(:amelie)
      get upvote_path(work, user)

      expect {
        get upvote_path(work, user)
      }.wont_change "Vote.count"
    end
  end
end
