# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    country "India"
    state "Karnataka"
    city "Bangalore"
    name "MyString"
    latitude "12.9667"
    longitude "77.5667"
  end
end
