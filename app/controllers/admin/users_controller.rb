class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.order(created_at: :desc).page(params[:page])
  end

  def update
    @user = User.find(params[:id])
    requested_role = params.dig(:user, :role)
    if User.roles.key?(requested_role) && @user.update(role: requested_role)
      redirect_to admin_users_path, notice: "User updated."
    else
      redirect_to admin_users_path, alert: "Invalid role."
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
