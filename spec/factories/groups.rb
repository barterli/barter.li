# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    user_id 1
    title "MyString"
    description "MyText"
    is_private false
    status 1
  end
end
