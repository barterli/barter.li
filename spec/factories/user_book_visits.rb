# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_book_visit do
    user_id 1
    book_id 1
    time_spent 1
  end
end
