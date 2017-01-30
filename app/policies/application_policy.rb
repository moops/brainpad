class ApplicationPolicy
  attr_reader :user,  # User performing the action
              :record # Instance upon which action is performed

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "Must be signed in shithead!." unless user
    @user   = user
    @record = record
  end

  def index?
    user
  end

  def show?
    user && (user.admin? || record.person == user)
  end

  def new?
    create?
  end

  def create?
    user
  end

  def edit?
    update?
  end

  def update?
    user && (user.admin? || record.person == user)
  end

  def destroy?
    user && (user.admin? || record.person == user)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user
        user.admin? ? scope.all : scope.where(person: user)
      else
        scope.none
      end
    end
  end
end
