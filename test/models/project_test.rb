require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @project = Project.new(title: "My Project", description: "A project", user: @user)
  end

  test "should be valid with valid attributes" do
    assert @project.valid?
  end

  test "should require a title" do
    @project.title = nil
    assert_not @project.valid?
  end

  test "should default to planning status" do
    assert_equal "planning", @project.status
  end

  test "progress_percentage returns 0 with no tasks" do
    assert_equal 0, @project.progress_percentage
  end

  test "progress_percentage calculates completed tasks" do
    @project.save!
    @project.tasks.create!(title: "Done task", status: :done, user: @user)
    @project.tasks.create!(title: "Todo task", status: :todo, user: @user)
    assert_equal 50, @project.progress_percentage
  end

  test "should have many tasks" do
    assert_respond_to @project, :tasks
  end
end
