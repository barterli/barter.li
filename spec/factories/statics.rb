# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :static do
    title "MyString"
    body "MyText"
    status false
    page_name "MyString"
  end
end
