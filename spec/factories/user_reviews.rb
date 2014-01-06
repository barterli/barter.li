# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_review do
    user_id 1
    body "MyText"
    moderate "MyString"
    stars 1
  end
end
