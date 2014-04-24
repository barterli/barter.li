# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_like, :class => 'UserLikes' do
    book_id 1
    user_id 1
  end
end
