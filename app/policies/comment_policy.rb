class CommentPolicy < ApplicationPolicy
  def destroy?
    record.user == user || user.admin?
  end
end
