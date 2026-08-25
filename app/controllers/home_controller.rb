class HomeController < ApplicationController
  def index
    @featured_jobs = Job.published.recent.limit(6)
    @recent_posts = Post.published.recent.limit(3)
    @featured_products = Product.recent.limit(4)
    @stats = {
      jobs: Job.published.count,
      users: User.count,
      companies: Company.count,
      projects: Project.count
    }
  end
end
