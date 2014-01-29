# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    user_id 1
    group_id 1
    body "MyText"
    title "MyString"
    publish_type 1
    status 1
  end
end
