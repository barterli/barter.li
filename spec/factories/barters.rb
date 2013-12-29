# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :barter do
    user_id 1
    notifier_id 1
    book_id 1
    exchange_book_id 1
    exchange_items "MyString"
    country "MyString"
    state "MyString"
    city "MyString"
    street "MyString"
    address "MyString"
    place "MyString"
    time "2013-12-29 10:27:05"
    date "2013-12-29"
  end
end
