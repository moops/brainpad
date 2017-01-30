FactoryGirl.define do
  factory :account do
    name %w(saving chequing credit).sample
    units 25
    price 1
    person
  end

  factory :contact do
    name 'test contact'
    email 'test@raceweb.ca'
    phone_home '123-456-7890'
    address '123 fake st'
    city 'wherever'
    person
  end

  factory :connection do
    username 'foobar'
    password 'foobar_password'
    url 'http://www.example2.com'
    person
  end

  factory :journal do
    entry 'test journal entry'
    entry_on Date.today
    person
  end

  factory :link do
    url 'http://www.example.com'
    name 'test link'
    person
  end

  factory :milestone do
    name 'test milestone'
    milestone_at Time.now - 2.months
    person
  end

  factory :payment do
    description "test payment"
    amount 25
    payment_on Date.today
    person
    after(:create) { |p| p.from_account = create(:account, person: p.person) }
  end

  factory :person do
    sequence(:username) { |n| "foo#{n}" }
    password { "#{username}_pass" }
    password_confirmation { "#{username}_pass" }

    trait :admin do
      authority 3
    end
  end

  factory :reminder do
    description 'test reminder'
    due_at Time.now + 6.hours
  end

  factory :workout do
    location 'test workout location'
    duration 60
    workout_on Date.today
    person
  end
end