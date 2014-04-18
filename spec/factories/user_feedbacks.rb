# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_feedback do
    user_id 1
    issue_id 1
    issue_url "MyString"
    message "MyText"
    title "MyString"
    label "MyString"
  end
end
