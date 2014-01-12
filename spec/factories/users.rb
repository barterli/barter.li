# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo#{n}@example.com" }
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.now
  end
end
