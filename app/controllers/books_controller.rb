class BooksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :new, :my_books]
  respond_to :json, :html
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

  #call to open library to get book info
  def book_info_open_library
    client = Openlibrary::Client.new
    results = client.search(params[:q])
    respond_with results
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author, :isbn_10, :isbn_13, :edition, :print, :publication_year, :publication_month, :condition, :value, :status, :stage, :description, :visits, 
        :user_id, :prefered_place, :tag_ids, :prefered_time, :image, :image_cache, :goodreads_id, :publisher)
    end
end
