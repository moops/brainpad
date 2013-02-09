FactoryGirl.define do
  factory :person do
    sequence(:username) { |n| "foo#{n}" }
    password { "#{username}_pass" }
    password_confirmation { "#{username}_pass" }
  end
  
  factory :account do
    name "Foo"
    units 25
    price 1
  end
  
  factory :payment do
    description "test payment"
    amount 25
    account
  end
end