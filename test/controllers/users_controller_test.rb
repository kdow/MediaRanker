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
    before do
      post login_path, params: @login_data
    end

    it "will logout user" do
      post logout_path

      expect(session[:user_id]).must_equal nil
    end

    it "will respond with redirect" do
      post logout_path

      must_redirect_to root_path
    end
  end
end
