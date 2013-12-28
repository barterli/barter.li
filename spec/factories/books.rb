# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "MyString"
    author "MyString"
    isbn_10 "MyString"
    isbn_13 "MyString"
    edition 1
    print 1
    publication_year 1
    publication_month "MyString"
    condition "MyString"
    value 1
    status false
    stage 1
    description "MyText"
    visits 1
    user_id 1
    prefered_place "MyString"
    prefered_time "MyString"
  end
end
