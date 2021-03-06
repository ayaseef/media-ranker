require "test_helper"

describe UsersController do
  it "must get login_form" do
    get users_login_form_url
    must_respond_with :success
  end

  # it "must get login" do
  #   get users_login_url
  #   must_respond_with :success
  # end

  it "can get the login form" do
    get login_path
    must_respond_with :success
  end

  describe "logging in" do
    it "can login a new user" do
      # Arrange
      user_hash = {
        user: {
          username: "Grace Hopper"
        }
      }
      expect {
        # Act
        post login_path, params: user_hash
      }.must_differ "User.count", 1

      must_respond_with :redirect
      user = User.find_by(username: user_hash[:user][:username])

      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal user_hash[:user][:username]
    end
  end
  describe "index" do
    it "responds with success when there are many users saved" do
      User.create username: "ayesha"
      get users_path
      must_respond_with :success
    end
  end
  describe "current" do
    it "returns 200 OK for a logged-in user" do
      # Arrange
      perform_login

      # Act
      get current_user_path

      # Assert
      must_respond_with :success
    end
  end
  describe "show" do
    before do
      User.create(username: "ayesha")
    end
    it "responds with success when showing an existing valid work" do
      id = User.find_by(username:"ayesha")[:id]
      get user_path(id)
      must_respond_with :success
    end
  end
end
