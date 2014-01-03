# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_track do
    user_id 1
    sent_for "MyString"
    date "2014-01-03"
  end
end
