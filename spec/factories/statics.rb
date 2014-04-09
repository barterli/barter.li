# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :static do
    page_name "MyString"
    body "MyText"
    title "MyString"
  end
end
