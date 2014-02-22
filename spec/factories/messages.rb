# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    body "MyText"
    msg_from 1
    msg_to 1
    msg_id "MyString"
  end
end
