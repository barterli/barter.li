class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :new, :my_books, :add_wish_list]
  respond_to :json, :html, only: [:add_wish_list, :book_info]
  # GET /books
  # GET /books.json 
  def index
    @books = current_user.books
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @book.book_visit_count
    if(session["warden.user.user.key"].present?)
      @book.book_visit_user(session["warden.user.user.key"][0][0])
    end
  end

  # GET /books/new
  def new 
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    @book = current_user.books.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = current_user.books.new(book_params)
    respond_to do |format|
      if @book.save
        WishListWorker.perform_async(@book.id)  # for background wishlist processing
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book = current_user.books.find(params[:id])
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = current_user.books.find(params[:id])
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  # Get list of users book
  def my_books
    @books = current_user.books
  end
 
  # get /book_info
  def book_info
    results = book_info_goodreads_library
    respond_with results
  end
  
  # call to open library to get book info
  def book_info_open_library
    client = Openlibrary::Client.new
    results = client.search(params[:q])
  rescue
    []
  end
 
 # call to goodreads library to get book info
  def book_info_goodreads_library
    client = Goodreads::Client.new(Goodreads.configuration)
    results = client.book_by_title(params[:q])
  rescue
    []
  end

  # wish list for book title and author
  def add_wish_list
    @wish_list = current_user.wish_lists.new(wish_list_params)
    if(@wish_list.save)
      respond_with(@wish_list)
    else
      respond_with(@wish_list.errors)
    end
  end

 # post /book_suggestions
  def book_suggestions
      book_titles = Array.new()
      book_titles << goodreads_titles 
      book_titles = book_titles.flatten.compact
      render json: book_titles.uniq
  end

  private

    def goodreads_titles
      arr = Array.new
      client = Goodreads::Client.new(Goodreads.configuration)
      search = client.search_books(params[:q])
      search.results.work.each do |book|
        arr << book.best_book.title.to_s 
      end
      return arr
    rescue
      []
    end

    def openlibrary_titles
      arr = Array.new
      openlibrary = Openlibrary::Client.new
      search = openlibrary.search(params[:q])
      search.each do |result|
        arr << result.title.to_s
      end
      return arr
    rescue
      []
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author, :isbn_10, :isbn_13, :edition, :print, :publication_year, :publication_month, :condition, :value, :status, :stage, :description, :visits, 
        :user_id, :prefered_place, {:tag_ids => []}, :prefered_time, :image, :image_cache, :goodreads_id, :publisher, :language_code, :pages, :image_url)
    end

    def wish_list_params
      params.require(:wish_list).permit(:tilte, :author)
    end 
end
