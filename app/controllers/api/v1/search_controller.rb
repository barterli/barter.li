# @restful_api 1.0
#
# Search books
#
class Api::V1::SearchController < Api::V1::BaseController
 
  # @url /search
  # @action GET 
  # 
  # get books
  #
  # @optional [String] search search string (title only)
  # @optional [String] latitude Latitude coordinate
  # @optional [String] longitude Longitude coordinate
  # @optional [String] radius Radius of book to search
  # @optional [Integer] page Page number
  # @optional [Integer] per number of results to return
  # @example_request_description Let's search a book
  # 
  # @example_request
  #    ```json
  #    {  
  #     "search": "ra"
  #       "page": 1
  #        "per": 10
  #     }
  #    }
  #    ```
  # @example_response_description returns search array object
  # @example_response
  #    ```json
  #       {
  #          "search": [
  #              {
  #                  "id": 6,
  #                  "title": "rails",
  #                  "author": "rails-to-trails",
  #                  "publication_year": null,
  #                  "publication_month": "",
  #                  "image_url": "http://localhost:3000/fallback/1_default.png",
  #                  "barter_type": null,
  #                  "location": null,
  #                  "tags": [],
  #                  "id_book": null
  #              },
  #              {
  #                  "id": 7,
  #                  "title": "rails",
  #                  "author": "rails-to-trails",
  #                  "publication_year": null,
  #                  "publication_month": "",
  #                  "image_url": "http://localhost:3000/fallback/1_default.png",
  #                  "barter_type": null,
  #                  "location": null,
  #                  "tags": [],
  #                  "id_book": null
  #              },
  #              {
  #                  "id": 8,
  #                  "title": "rails",
  #                  "author": "rails-to-trails",
  #                  "publication_year": null,
  #                  "publication_month": "",
  #                  "image_url": "http://localhost:3000/fallback/1_default.png",
  #                  "barter_type": null,
  #                  "location": null,
  #                  "tags": [],
  #                  "id_book": null
  #              },
  #
  #
  #          ]
  #      }
  #    }
  #    ```
  def search
    params[:radius] ||= 50
    params[:per] ||= 18
  	params[:search_filter] = {:latitude => params[:latitude], :longitude => params[:longitude]}
    params[:search_filter][:radius] = params[:radius]
    params[:search_filter][:title] = params[:search]
  	# if(params[:search].to_s =~ /^[0-9]{10}$|^[0-9]{13}$/ )
  	#   params[:search_filter][:isbn] = params[:search]
  	# else
  	#   params[:search_filter][:book_or_author] = params[:search]
  	# end
    @books = Book.search(params[:search_filter]).page(params[:page]).per(params[:per]).records
    render json: @books, serializer: nil 
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  
  def add_wishlist
    if(@books.blank? && current_user.present? && params[:search][:title].present?)
      current_user.wish_lists.create!(:title => params[:search][:title])
      return
    end
    if(@books.blank? && current_user.present? && params[:search][:author].present?)
      current_user.wish_lists.create!(:author => params[:search][:author])
      return
    end
  end

end