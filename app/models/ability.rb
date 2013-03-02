class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= Person.new # guest user
    user.roles=['user'] if user.new_record?
    
    if user.role? :admin
      can :manage, :all
    elsif user.role? :user
      can :read, :all
      can :manage, Person do |p|
        p.eql?(user) or p.new_record?
      end
      can :manage, Contact do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Connection do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Journal do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Link do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Milestone do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Payment do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Reminder do |c|
        c.try(:person) == user or c.new_record?
      end
      can :manage, Workout do |c|
        c.try(:person) == user or c.new_record?
      end
      
    end
  end
end