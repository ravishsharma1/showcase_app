class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_jobs = current_user.jobs.order(created_at: :desc).limit(5)
    @my_applications = current_user.job_applications.includes(:job).order(created_at: :desc).limit(5)
    @my_orders = current_user.orders.order(created_at: :desc).limit(5)
    @my_projects = current_user.projects.order(created_at: :desc).limit(5)
    @my_tasks = current_user.tasks.order(created_at: :desc).limit(5)
    @my_posts = current_user.posts.order(created_at: :desc).limit(5)
  end
end
