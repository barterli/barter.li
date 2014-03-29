class Api::V1::BooksController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create, :index, :edit, :update, :destroy, :new, 
                :change_owner, :my_books, :set_wish_list]
 
  def index
    @books = current_user.books
    if stale?(:etag => "index_books_"+current_user.id, :last_modified =>  @books.maximum(:updated_at), :public => true)
      render :json => @books
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    @book.book_visit_count
    if(current_user.present?)
      @book.book_visit_user(current_user.id)
    end
    if stale?(:etag => @book.id, :last_modified => @book.updated_at, :public => true)
      render json: @book 
    end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # POST /books
  # POST /books.json
  def create
    tag_ids = get_tag_ids
    @book = current_user.books.new(book_params.merge(location_id: book_location, tag_ids: tag_ids))
    if @book.save
      WishListWorker.perform_async(@book.id)  # for background wishlist processing
      render json: @book 
    else
      render json: {error_message: @book.errors, error_code: Code[:error_resource]}, status: Code[:status_error]
    end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def get_tag_ids
    return [] if params[:tag_names].blank?
    ids = Array.new
    params[:tag_names].each do |name|
      tag = Tag.find_by(name: name.downcase)
      ids << tag.id if tag.present?
    end
    return ids
  end
  
  def book_location
    if(params[:location].present?)
      return Location.set_location(params[:location]).id
    else
      return current_user.try(:preferred_location).try(:id)
    end
  end
  
  # GET /tags
  def get_tags
    render json: Tag.all, status: Code[:status_success] 
  end
  
  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book = current_user.books.find(params[:id])
      if @book.update(book_params)
        render json: @book  
      else
        render json: {error_message: @book.errors, error_code: Code[:error_resource]}, status: Code[:status_error]
      end
  end

  # POST /change_owner
  def change_owner
    @book = current_user.books.find(params[:book_id])
    @book.user_id = params[:user_id]
    @book.tags.destroy
    @book.tag_ids = [Tag.find_by(name:'private').id]
    @book.save
    render json:{}
  rescue => e
    render json:{error_code: Code[:error_rescue], error_message: e.message }, status: Code[:status_error]
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = current_user.books.find(params[:id])
    @book.destroy
    render json { head :no_content }
  end
 
  # GET /book_info
  def book_info
    results = book_info_goodreads_library
    render json: results
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
  
  # call to open library to get book info
  def book_info_open_library
    client = Openlibrary::Client.new
    results = client.search(params[:q])
  end


 # call to goodreads library to get book info
  def book_info_goodreads_library
    client = Goodreads::Client.new(Goodreads.configuration)
    results = client.book_by_title(params[:q]) if (params[:t] == "title" || params[:t].blank?)
    results = client.book_by_isbn(params[:q]) if params[:t] == "isbn"
    return results
  end

  # POST '/wish_list'
  def set_wish_list
    @wish_list = current_user.wish_lists.new(wish_list_params)
    if(@wish_list.save)
      render json: @wish_list
    else
      render json: {}, status: Code[:status_error]
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def get_wish_list
    @wish_lists = current_user.wish_lists
    render json: @wish_lists
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

 # GET /book_suggestions
  def book_suggestions
    book_titles = Array.new()
    book_titles << goodreads_titles 
    book_titles = book_titles.flatten.compact
    render json: book_titles.uniq
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  private

    def goodreads_titles
      arr = Array.new
      client = Goodreads::Client.new(Goodreads.configuration)
      search = client.search_books(params[:q])
      return search.results.work.best_book.title unless search.results.work.kind_of?(Array)
      search.results.work.each do |book|
        arr << book.best_book.title.to_s 
      end
      return arr
    end

    def openlibrary_titles
      arr = Array.new
      openlibrary = Openlibrary::Client.new
      search = openlibrary.search(params[:q])
      search.each do |result|
        arr << result.title.to_s
      end
      return arr
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author, :isbn_10, :isbn_13, :edition, :print, :publication_year, :publication_month, :condition, :value, :status, :stage, :description, :visits, 
        :user_id, :location_id, :prefered_place, {:tag_ids => []}, :prefered_time, :image, :image_cache, :goodreads_id, :publisher, :language_code, :pages, :image_url)
    end

    def wish_list_params
      params.require(:wish_list).permit(:title, :author)
    end 

end