require 'spec_helper'

describe Book do
  before(:each) do
     @attr = {
       :title => "Rails",
       :author => "Dave",
     }
   end
   it "should create Book with title and author in lowercase" do
     book = Book.create(@attr)
     book.title.chr.ord.should_not eq("R".chr.ord)
     book.title.chr.upcase.ord.should eq("R".chr.ord)
   end
   
   it "should increase book visit count" do
     book = Book.create(@attr)
     book.book_visit_count
     book.visits.should eq(1)
   end

   it "return book barter categories" do
     categories = Book.barter_categories
     categories.kind_of?(Hash).should be_true
   end

   it "records visitor to book" do
    book = Book.create(@attr)
    book.book_visit_user(1)
    visit = UserBookVisit.last
    visit.user_id.should eq(1)
    visit.book_id.should eq(book.id)
   end
end

