require "test_helper"

class JobTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @company = Company.create!(name: "Test Co", user: @user)
    @job = Job.new(
      title: "Ruby Developer",
      description: "Build great software",
      company: @company,
      status: :published,
      employment_type: :full_time
    )
  end

  test "should be valid with valid attributes" do
    assert @job.valid?
  end

  test "should require a title" do
    @job.title = nil
    assert_not @job.valid?
  end

  test "should require a description" do
    @job.description = nil
    assert_not @job.valid?
  end

  test "should default to draft status" do
    job = Job.new(title: "X", description: "Y", company: @company)
    assert_equal "draft", job.status
  end

  test "published scope returns only published jobs" do
    @job.save!
    Job.create!(title: "Draft", description: "D", company: @company, status: :draft)
    assert_equal 1, Job.published.count
  end

  test "salary_range returns formatted range" do
    @job.salary_min = 50_000
    @job.salary_max = 80_000
    assert_equal "$50000 - $80000", @job.salary_range
  end

  test "salary_range returns Not specified when nil" do
    assert_equal "Not specified", @job.salary_range
  end

  test "should have many job_applications" do
    assert_respond_to @job, :job_applications
  end
end
