require "test_helper"

describe UsersController do
  before do
    @user = User.first
    @login_data = {
      user: {
        username: @user.username,
      },
    }
  end

  describe "index" do
    it "can get index" do
      get users_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "returns a 404 status code if the user doesn't exist" do
      user_id = 12345392487
      expect(User.find_by(id: user_id)).must_be_nil

      get user_path(user_id)

      must_respond_with :not_found
    end

    it "functions for a user that exists" do
      get user_path(@user.id)

      must_respond_with :success
    end
  end

  describe "login_form" do
    it "can get the login page" do
      get login_path

      must_respond_with :success
    end
  end

  describe "login" do
    it "will login user" do
      post login_path, params: @login_data

      expect(session[:user_id]).must_equal @user.id
    end

    it "will respond with redirect" do
      post login_path, params: @login_data

      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "will logout user" do
      perform_login
      post logout_path

      expect(session[:user_id]).must_equal nil
    end

    it "will respond with redirect" do
      post logout_path

      must_redirect_to root_path
    end
  end
end
