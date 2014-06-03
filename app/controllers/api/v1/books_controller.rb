# @restful_api 1.0
#
# book creation and getting book objects
#
class Api::V1::BooksController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:create, :index, :edit, :update, :destroy, :new, 
                :change_owner, :my_books, :set_wish_list, :like_book, :unlike_book]
 
  def index
    @books = current_user.books
    # if stale?(:etag => "index_books_"+current_user.id, :last_modified =>  @books.maximum(:updated_at), :public => true)
      render :json => @books
    # end
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
    # if stale?(:etag => @book.id, :last_modified => @book.updated_at, :public => true)
      render json: @book 
    # end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /books
  # @action POST
  #
  # create new book. requires token authentication headers
  #
  # @required [String] title Title of the book
  # @optional [String] isbn_13 Isbn 13 of the book
  # @optional [String] isbn_10 Isbn 13 of the book
  # @optional [String] author Author of the book
  # @optional [String] edition Edition of the book
  # @optional [String] description Description of the book
  # @optional [String] value price of the book
  #
  # @response [Book] The created book
  #
  # @example_request_description Let's try to create a book
  # @example_request
  #    ```json
  #      {
  #       "book": {
  #       "title": "test",
  #       }
  #     }
  #     ```
  # @example_response_description The book should be created correctly
  # @example_response
  #    ```json
  #      {
  #        "book": {
  #        "id": 14,
  #        "title": "test",
  #        "author": null,
  #        "publication_year": null,
  #        "publication_month": null,
  #        "image_url": "http://162.243.198.171:/fallback/1_default.png",
  #        "barter_type": null,
  #        "location": {
  #           "id": 17,
  #            "country": null,
  #           "state": null,
  #            "city": null,
  #            "address": null,
  #            "postal_code": null,
  #            "locality": null,
  #            "name": null,
  #            "latitude": "12.7777",
  #            "longitude": "12.34546",
  #            "id_location": "804f2bbb36fd58ee"
  #        },
  #        "tags": [],
  #        "id_book": "4bcbfd3bc31545ac"
  #      }
  #    }
  #    ```
  def create
    tag_ids = get_tag_ids
    @book = current_user.books.new(book_params.merge(location_id: book_location))
    if @book.save
      @book.tag_ids = tag_ids
      # WishListWorker.perform_async(@book.id)  # for background wishlist processing
      render json: @book 
    else
      render json: {error_message: @book.errors, error_code: Code[:error_resource]}, status: Code[:status_error]
    end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def get_tag_ids
    return [] if params[:book][:tag_names].blank?
    ids = Array.new
    params[:book][:tag_names].each do |name|
      tag = Tag.where(name: name.downcase).first_or_create
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
  
  # @url /books
  # @action PUT
  #
  # create new book. requires token authentication headers
  # example Authorization Token token="4Fqev-DxCSL1krsZvuAY", email="sssnn@gmail.com"
  #
  # @required [Integer] id Id of the book
  # @required [String] title Title of the book
  # @optional [String] isbn_13 Isbn 13 of the book
  # @optional [String] isbn_10 Isbn 13 of the book
  # @optional [String] author Author of the book
  # @optional [String] edition Edition of the book
  # @optional [String] description Description of the book
  # @optional [String] value price of the book
  #
  # @response [Book] The created book
  #
  # @example_request_description Let's try to create a book
  # @example_request
  #    ```json
  #      {
  #       "book": {
  #       "title": "test",
  #       }
  #     }
  #     ```
  # @example_response_description The book should be created correctly
  # @example_response
  #    ```json
  #      {
  #        "book": {
  #        "id": 14,
  #        "title": "test",
  #        "author": null,
  #        "publication_year": null,
  #        "publication_month": null,
  #        "image_url": "http://162.243.198.171:/fallback/1_default.png",
  #        "barter_type": null,
  #        "location": {
  #           "id": 17,
  #            "country": null,
  #           "state": null,
  #            "city": null,
  #            "address": null,
  #            "postal_code": null,
  #            "locality": null,
  #            "name": null,
  #            "latitude": "12.7777",
  #            "longitude": "12.34546",
  #            "id_location": "804f2bbb36fd58ee"
  #        },
  #        "tags": [],
  #        "id_book": "4bcbfd3bc31545ac"
  #      }
  #    }
  #    ``
  def update
    tag_ids = get_tag_ids
    @book = current_user.books.find(params[:id])
      if @book.update_attributes(book_params)
        @book.tag_ids = tag_ids
        render json: @book  
      else
        render json: {error_message: @book.errors, error_code: Code[:error_resource]}, status: Code[:status_error]
      end
  end


  # POST /change_owner
  def change_owner
    @book = current_user.books.find(params[:book_id])
    @user = User.find_by(id_user: params[:user_id])
    @book.user_id = @user.id
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
    render json:{}
  end

  # @url /book_info
  # @action GET
  # 
  # suggest book details
  #
  # @required [String] q title or isbn  of the book to get details 
  # @example_request_description Let's send a isbn string of a book
  # 
  # @example_request
  #    ```json
  #    {  
  #     q: 9780977616602
  #     }
  #    ```
  # @example_response_description array of book titles matching query
  # @example_response
  #    ```json
  #        {
  #            {
  #                "id": "519",
  #                "title": "Rails Recipes (Pragmatic Programmers)",
  #                "isbn": "0977616606",
  #                "isbn13": "9780977616602",
  #                "asin": "",
  #                "image_url": "http://www.goodreads.com/assets/nocover/111x148.png",
  #                "small_image_url": "http://www.goodreads.com/assets/nocover/60x80.png",
  #                "publication_year": null,
  #                "publication_month": null,
  #                "publication_day": null,
  #                "publisher": null,
  #                "language_code": null,
  #               "is_ebook": "false",
  #                "description": null,
  #                "work": {
  #                    "best_book_id": 519,
  #                    "books_count": 2,
  #                    "default_chaptering_book_id": null,
  #                    "default_description_language_code": null,
  #                    "desc_user_id": null,
  #                    "id": 4781,
  #                    "media_type": null,
  #                    "original_language_id": null,
  #                    "original_publication_day": null,
  #                    "original_publication_month": null,
  #                    "original_publication_year": null,
  #                    "original_title": "Rails Recipes (Pragmatic Programmers)",
  #                    "rating_dist": "4:46|3:56|2:11|5:19|total:132",
  #                    "ratings_count": 193,
  #                    "ratings_sum": 688,
  #                    "reviews_count": 412,
  #                    "text_reviews_count": 7
  #                },
  #                "average_rating": "3.56",
  #                "num_pages": "",
  #                "format": "",
  #                "edition_information": "",
  #                "ratings_count": "181",
  #                "text_reviews_count": "4",
  #                "url": "http://www.goodreads.com/book/show/519.Rails_Recipes",
  #                "link": "http://www.goodreads.com/book/show/519.Rails_Recipes",
  #                "authors": {
  #                    "author": {
  #                        "id": "302",
  #                        "name": "Chad Fowler",
  #                        "image_url": "http://d202m5krfqbpi5.cloudfront.net/authors/1215370168p5/302.jpg",
  #                        "small_image_url": "http://d202m5krfqbpi5.cloudfront.net/authors/1215370168p2/302.jpg",
  #                        "link": "http://www.goodreads.com/author/show/302.Chad_Fowler",
  #                        "average_rating": "3.95",
  #                        "ratings_count": "2242",
  #                        "text_reviews_count": "169"
  #                    }
  #                },......
  #    }
  #    ```
  def book_info
    results = book_info_goodreads_library
    render json: results
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
  
  # @url /like_book
  # @action POST
  # 
  # current user like a book
  #
  # @required [Integer] book_id  book_id to like
  # @example_request_description Let's send a book_id to like
  # 
  # @example_request
  #    ```json
  #    {  
  #     book_id: 1
  #     }
  #    ```
  # @example_response_description a userlike object
  # @example_response
  #    ```json
  #        {
  #            {
  #              "id": 1,
  #              "book_id": 3,
  #              "user_id": 4,
  #              "created_at": "2014-04-24T09:29:52.000Z",
  #              "updated_at": "2014-04-24T09:29:52.000Z"
  #          }   
  #    }
  #    ```
  def like_book
    like = UserLike.where(user_id: current_user.id, book_id: params[:book_id]).first
    like = UserLike.create!(user_id: current_user.id, book_id: params[:book_id]) if like.blank?
    render json: like
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /unlike_book
  # @action DELETE
  # 
  # current user unlike a book
  #
  # @required [Integer] book_id  book_id to unlike
  # @example_request_description Let's send a book_id to unlike
  # 
  # @example_request
  #    ```json
  #    {  
  #     book_id: 1
  #     }
  #    ```
  # @example_response_description a sucess 200 ok code
  # @example_response
  #    ```json
  #        {
  #            {
  #          }   
  #    }
  #    ```
  def unlike_book
    like = UserLike.where(user_id: current_user.id, book_id: params[:book_id]).first
    like.destroy! if like.present?
    render json: {}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /is_book_liked
  # @action GET
  # 
  # get the user like status of book
  #
  # @required [Integer] book_id  book_id to get like status
  # @example_request_description Let's send a book_id to get status
  # 
  # @example_request
  #    ```json
  #    {  
  #     book_id: 3
  #     }
  #    ```
  # @example_response_description true or false 
  # @example_response
  #    ```json
  #        {
  #            {
  #              like: true
  #          }   
  #    }
  #    ```
  def is_book_liked
    user_like = UserLike.where(user_id: current_user.id, book_id: params[:book_id]).first
    is_liked = user_like.present? ? true : false 
    render json: {like: is_liked}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def author_details
    results = author_details_goodreads_library
    render json: results
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
  
  # call to open library to get book info
  def book_info_open_library
    client = Openlibrary::Client.new
    results = client.search(params[:q])
  end


   # call to goodreads library to get author details
  def author_details_goodreads_library
    client = Goodreads::Client.new(Goodreads.configuration)
    results = client.author_by_name(params[:q]) 
    return results
  end

 # call to goodreads library to get book info
  def book_info_goodreads_library
    client = Goodreads::Client.new(Goodreads.configuration)
    results = client.book_by_title(params[:q]) if (params[:t] == "title" || params[:t].blank?)
    results = client.book_by_isbn(params[:q]) if params[:t] == "isbn"
    return results
  end

  # @url /wish_list
  # @action POST
  # 
  # set wishlist for book title
  #
  # @required [String] title  title of book
  # @example_request_description Let's send a title for wish list
  # 
  # @example_request
  #    ```json
  #    {  
  #      "title": "rails"
  #     }
  #    ```
  # @example_response_description wish_list object
  # @example_response
  #    ```json
  #        {
  #            {
  #              {
  #                  "id": 1,
  #                  "user_id": 4,
  #                  "title": "rails",
  #                  "author": null,
  #                  "in_locality": false,
  #                  "in_city": true,
  #                  "created_at": "2014-04-24T09:49:52.434Z",
  #                  "updated_at": "2014-04-24T09:49:52.434Z"
  #              }
  #          }   
  #    }
  #    ```
  def set_wish_list
    @wish_list = current_user.wish_lists.where(title: params[:title]).first_or_initialize
    if(@wish_list.save)
      render json: @wish_list
    else
      render json: {}, status: Code[:status_error]
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /wish_list
  # @action GET
  # 
  # get wishlist for current user
  #
  # 
  # @example_request_description Let's send a title for wish list
  # 
  # @example_request
  #    ```json
  #    {  
  #      
  #     }
  #    ```
  # @example_response_description wish_list object
  # @example_response
  #    ```json
  #          {
  #              "books": [
  #                  {
  #                      "books": {
  #                          "id": 1,
  #                          "user_id": 4,
  #                          "title": "rails",
  #                          "author": null,
  #                          "in_locality": false,
  #                          "in_city": true,
  #                          "created_at": "2014-04-24T09:49:52.000Z",
  #                          "updated_at": "2014-04-24T09:49:52.000Z"
  #                      }
  #                  }
  #              ]
  #          }
  #    ```
  def get_wish_list
    @wish_lists = current_user.wish_lists
    render json: @wish_lists
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
  

  # @url /book_suggestions
  # @action GET
  # 
  # suggest book titles
  #
  # @required [String] q title or isbn  of the book
  # @example_request_description Let's send a title string of a book
  # 
  # @example_request
  #    ```json
  #    {  
  #     q: rails
  #     }
  #    ```
  # @example_response_description array of book titles matching query
  # @example_response
  #    ```json
  #        {
  #         {
  #            "books": [
  #                "Rails Recipes (Pragmatic Programmers)",
  #                "North to the Rails",
  #                "Rails",
  #                "The Rails Way",
  #                "The Rails 3 Way",
  #                "Agile Web Development with Rails: A Pragmatic Guide",
  #                "Off The Rails",
  #                "Bryant & May Off the Rails (Bryant & May, #8)",
  #                "Objects on Rails",
  #                "Advanced Rails",
  #                "Advanced Rails Recipes",
  #                "Enterprise Rails",
  #                "Tupelo Rides the Rails",
  #                "Ruby on Rails 3 Tutorial: Learn Rails by Example (Addison-Wesley Professional Ruby Series)",
  #                "Rails Antipatterns: Best Practice Ruby on Rails Refactoring"
  #            ]
  #        }
  #    }
  #    ```
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
        :user_id, :location_id, :prefered_place, {:tag_ids => []}, :prefered_time, :image, :image_cache, :goodreads_id, :publisher, :language_code, :pages, :image_url, :ext_image_url)
    end


end