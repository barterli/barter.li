# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_share do
    user_id 1
    shared_user_id 1
  end
end
