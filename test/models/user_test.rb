require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :user
    )
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require a name" do
    @user.name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:name], "can't be blank"
  end

  test "should default to user role" do
    user = User.new(name: "X", email: "x@example.com", password: "password123")
    assert_equal "user", user.role
  end

  test "admin? returns true for admin role" do
    @user.role = :admin
    assert @user.admin?
  end

  test "client? returns true for client role" do
    @user.role = :client
    assert @user.client?
  end

  test "should have many companies" do
    assert_respond_to @user, :companies
  end

  test "should have many job_applications" do
    assert_respond_to @user, :job_applications
  end

  test "should have many orders" do
    assert_respond_to @user, :orders
  end

  test "should have many projects" do
    assert_respond_to @user, :projects
  end
end
