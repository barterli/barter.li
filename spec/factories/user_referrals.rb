# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_referral do
    referral_id "MyString"
    user_id 1
    referral_token "MyString"
  end
end
