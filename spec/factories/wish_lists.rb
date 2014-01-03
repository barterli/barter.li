# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wish_list do
    user_id 1
    title "MyString"
    author "MyString"
    in_locality false
     ""
  end
end
