class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def show
    @stats = {
      users: User.count,
      jobs: Job.count,
      products: Product.count,
      orders: Order.count,
      posts: Post.count,
      projects: Project.count
    }
    @recent_users = User.order(created_at: :desc).limit(10)
  end

  private

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
