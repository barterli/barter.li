class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :new, :my_books, :add_wish_list]
  respond_to :json, :html, only: [:add_wish_list, :book_info]
  include Books
  
end
