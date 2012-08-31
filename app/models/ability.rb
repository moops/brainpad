class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= Person.new # guest user
    
    if user.role? :admin
      can :manage, :all
    elsif user.role? :user
      can :read, :all
    end
  end
end