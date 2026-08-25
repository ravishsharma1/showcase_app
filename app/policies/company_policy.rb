class CompanyPolicy < ApplicationPolicy
  def create?
    user.client? || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.user == user || user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user || user.admin?
  end
end
