class Api::V1::BooksController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:set_user_preferred_location, :create, :index, :edit, :update, :destroy, :new, :my_books, :add_wish_list]
  include Books

  # def add_book
  #   @book = current_user.books.new(book_params)
  #   @book.location.id = current_user.try(:preferred_location).try(:id)
  #     if @book.save
  #       WishListWorker.perform_async(@book.id)  # for background wishlist processing
  #       render :json => { :status => "success", :location => @book}
  #     else
  #       render :json => { @book.errors, :status => "error"} 
  #     end
  # end

  # private     # Never trust parameters from the scary internet, only allow the white list through.
    
  #   def book_params
	 #  params.require(:book).permit(:title, :author, :isbn_10, :isbn_13, :edition, :print, :publication_year, :publication_month, :condition, :value, :status, :stage, :description, :visits, 
	 #      :user_id, :prefered_place, {:tag_ids => []}, :prefered_time, :image, :image_cache, :goodreads_id, :publisher, :language_code, :pages, :image_url)
  #   end

end