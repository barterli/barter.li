# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    country "MyString"
    state "MyString"
    city "MyString"
    locality "MyString"
    name "MyString"
    latitude "MyString"
    longitude "MyString"
  end
end
