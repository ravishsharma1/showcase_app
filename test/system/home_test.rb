require "application_system_test_case"

class HomeSystemTest < ApplicationSystemTestCase
  test "visiting the home page shows the platform title" do
    visit root_path

    assert_selector "h1", text: "Your all-in-one freelancer platform"
    assert_link "Browse Jobs"
    assert_link "Explore Marketplace"
  end

  test "browsing jobs shows the job board" do
    visit jobs_path

    assert_selector "h1", text: "Browse Jobs"
    assert_selector "input[type=search]"
  end

  test "browsing the marketplace shows products" do
    visit products_path

    assert_selector "h1", text: "Marketplace"
  end

  test "browsing the blog shows posts" do
    visit posts_path

    assert_selector "h1", text: "Blog"
  end
end
