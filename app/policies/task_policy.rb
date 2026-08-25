class TaskPolicy < ApplicationPolicy
  def create?
    record.project.user == user || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.project.user == user || user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    record.project.user == user || user.admin?
  end
end
