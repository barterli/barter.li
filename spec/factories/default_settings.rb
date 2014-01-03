# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :default_setting do
    name ""
    value "MyString"
    status false
  end
end
