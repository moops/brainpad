class PersonPolicy < ApplicationPolicy
  def index?
    # index not implemented yet
    false
  end

  def create?
    # anyone can sign up
    true
  end

  def update?
    # logged in and admin or updating self
    user && (user.admin? || record == user)
  end

  def destroy?
    # logged in as an admin and not deleting self
    user && user.admin? && record.id != user.id
  end
end
