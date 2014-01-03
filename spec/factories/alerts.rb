# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alert do
    user_id 1
    thing_id 1
    thing_type "MyString"
    is_seen false
    reason "MyString"
    message "MyText"
  end
end
