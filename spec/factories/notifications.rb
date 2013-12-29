# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    user_id 1
    notifier_id 1
    message "MyText"
    parent_id 1
  end
end
