# @restful_api 1.0
#
# user creation and getting user objects
#
class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:update, :show, :get_share_token, :generate_share_token,
    :set_user_preferred_location, :user_preferred_location, :chat_block, :chat_unblock, 
    :set_user_review, :current_user_referral_books]
  
  

  # @url /user_profile
  # @action GET 
  # 
  # get profile of a user
  #
  # @required [Integer] id id array of the user
  # @example_request_description Let's send a id of a user
  # 
  # @example_request
  #    ```json
  #    {  
  #     id: 5
  #     }
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #            "users": [
  #                {
  #                    "id": 25,
  #                    "first_name": "test",
  #                    "last_name": "M",
  #                    "id_user": 988jkbkjgjgjhg,
  #                    "profile_image": "http://localhost:3000/fallback/1_default.png",
  #                     "description":"description here"
  #                       "location": {
  #                        "id": 6,
  #                        "country": "34535",
  #                        "state": null,
  #                        "city": null,
  #                        "locality": null,
  #                        "name": null,
  #                        "latitude": "12.334",
  #                        "longitude": "12.445",
  #                        "address": null,
  #                        "id_location": null,
  #                         "books": [
  #                                  {
  #                                      "id": 36,
  #                                      "title": "Quiet Quadrangles And Ivory Towers",
  #                                      "author": "Pauline Curtis",
  #                                      "publication_year": null,
  #                                      "publication_month": null,
  #                                      "value": null,
  #                                      "image_url": "http://162.243.198.171/assets/fallback/1_default-1613a70d06a262fc7635652906de7eb9.png",
  #                                      "barter_type": null,
  #                                      "location": {
  #                                          "id": 1,
  #                                          "country": null,
  #                                          "state": null,
  #                                          "city": null,
  #                                          "locality": null,
  #                                          "name": "Coffee On Canvas",
  #                                          "latitude": "12.93516201597191",
  #                                          "longitude": "77.63097871416265",
  #                                          "address": "#84, S.T.Bed Layout, 4th Block Koramangala",
  #                                          "id_location": "0bfb1f41ee40128d"
  #                                      },
  #                                      "tags": [
  #                                          "barter"
  #                                      ],
  #                                      "id_book": "8abbb9fe63bca9dc",
  #                                      "description": "",
  #                                      "isbn_10": null,
  #                                      "isbn_13": "9780955716300",
  #                                      "id_user": "df1435f617d4063a"
  #                                  }]
  #                    }
  #                }
  #            ]
  #        }
  #    }
  #    ```
  def user_profile
    user  = User.find_by(id_user: params[:id])
    # if stale?(:etag => "user_profile_"+user.id, :last_modified => user.updated_at, :public => true)
    render json: user, serializer: UserProfileSerializer
    # end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /user_profiles
  # @action GET 
  # 
  # get profiles of a users
  #
  # @required [Integer] ids id array of the user
  # @example_request_description Let's send a id of a user
  # 
  # @example_request
  #    ```json
  #    {  
  #     ids: [5]
  #     }
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #            "users": [
  #                {
  #                    "id": 25,
  #                    "first_name": "test",
  #                    "last_name": "M",
  #                    "id_user": 988jkbkjgjgjhg,
  #                    "profile_image": "http://localhost:3000/fallback/1_default.png",
  #                     "description":"description here"
  #                       "location": {
  #                        "id": 6,
  #                        "country": "34535",
  #                        "state": null,
  #                        "city": null,
  #                        "locality": null,
  #                        "name": null,
  #                        "latitude": "12.334",
  #                        "longitude": "12.445",
  #                        "address": null,
  #                        "id_location": null,
  #                         "books": [
  #                                  {
  #                                      "id": 36,
  #                                      "title": "Quiet Quadrangles And Ivory Towers",
  #                                      "author": "Pauline Curtis",
  #                                      "publication_year": null,
  #                                      "publication_month": null,
  #                                      "value": null,
  #                                      "image_url": "http://162.243.198.171/assets/fallback/1_default-1613a70d06a262fc7635652906de7eb9.png",
  #                                      "barter_type": null,
  #                                      "location": {
  #                                          "id": 1,
  #                                          "country": null,
  #                                          "state": null,
  #                                          "city": null,
  #                                          "locality": null,
  #                                          "name": "Coffee On Canvas",
  #                                          "latitude": "12.93516201597191",
  #                                          "longitude": "77.63097871416265",
  #                                          "address": "#84, S.T.Bed Layout, 4th Block Koramangala",
  #                                          "id_location": "0bfb1f41ee40128d"
  #                                      },
  #                                      "tags": [
  #                                          "barter"
  #                                      ],
  #                                      "id_book": "8abbb9fe63bca9dc",
  #                                      "description": "",
  #                                      "isbn_10": null,
  #                                      "isbn_13": "9780955716300",
  #                                      "id_user": "df1435f617d4063a"
  #                                  }]
  #                    }
  #                }
  #            ]
  #        }
  #    }
  #    ```
  def user_profiles
    users  = User.where(id_user: params[:ids].split(","))
    # if stale?(:etag => "user_profile_"+user.id, :last_modified => user.updated_at, :public => true)
    render json: users, each_serializer: UserProfileSerializer
    # end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /chat_block
  # @action POST
  # 
  # block users in chat
  #
  # @required [Integer] user_id guid of the user
  # @example_request_description Let's send a user_id of a user
  # 
  # @example_request
  #    ```json
  #    {  
  #     user_id: hjghj67565
  #     }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #         
  #    }
  #    ```
  def chat_block
    id = User.find_by(id_user: params[:user_id]).id
    is_blocked = current_user.chat_filters.where(block_id: id).first
    if(is_blocked.blank?)
      current_user.chat_block(id)
      render :json => {}
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /chat_unblock
  # @action POST
  # 
  # unblock users in chat
  #
  # @required [Integer] user_id guid of the user
  # @example_request_description Let's send a user_id of a user
  # 
  # @example_request
  #    ```json
  #    {  
  #     user_id: hjghj67565
  #     }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #         
  #    }
  #    ```
  def chat_unblock
    id = User.find_by(id_user: params[:user_id]).id
    is_blocked = current_user.chat_filters.where(block_id: id).first
    if(is_blocked.present?)
      is_blocked.delete
      render :json => {}
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # GET '/current_user_profile'
  def show
    user  = current_user
    # if stale?(:etag => "current_user_profile_"+user.id, :last_modified => user.updated_at, :public => true)
      render :json => {user: user, books: user.books}
    # end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def update
    user  = current_user
    if(user.update_attributes(user_profile_params))
      render json: user
    else
      render json: {error_code: Code[:error_resource], error_message: user.errors.full_messages},  status: Code[:status_error]
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end


  def set_profile_image
    current_user.profile = params[:profile]
    current_user.save!
    render json: {image_url: image_url, status: :success}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
  

  # @url /password_reset
  # @action GET 
  # 
  # send password reset token
  #
  # @required [String] email Email to send reset password token
  #
  # @response [User] The user object
  #
  # @example_request_description Let's send a password reset token
  # 
  # @example_request
  #    ```json
  #    {
  #      "email": "test@example.com"
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #       {
  #      
  #       }
  #    }
  #    ```
  def send_password_reset
    user = User.find_by(email: params[:email])
    if(user)
      user.send_password_reset
      render json: {}
    else
      render json: {error_code: Code[:error_resource], error_message: "no user found"}, status: Code[:status_error]
    end
  end
 
  # @url /password_reset
  # @action POST
  # 
  # set password reset 
  #
  # @required [String] email Email to set password
  # @required [String] token Token send to your email
  # @required [String] password New password to set
  # @example_request_description Let's set a password 
  # 
  # @example_request
  #    ```json
  #    {
  #      "email": "test@example.com",
  #      "password": "12345678",
  #      "token": "67059910"
  #    }
  #    ```
  # @example_response_description gives user object
  # @example_response
  #    ```json
  #      {
  #          "user": {
  #              "id": 9,
  #              "email": "surendarft@gmail.com",
  #              "description": null,
  #              "first_name": "surendar",
  #              "last_name": "ghgf",
  #              "location": null,
  #              "auth_token": "Qj2egLZTwe812gxSpDd8",
  #              "sign_in_count": 1,
  #              "id_user": null,
  #             "books": [
  #                  {
  #                      "id": 21,
  #                      "title": "rails",
  #                      "author": "rails-to-trails",
  #                      "publication_year": 2007,
  #                      "publication_month": "January",
  #                      "image_url": "http://localhost:3000/uploads/book/image/21/1662213-S.jpg",
  #                      "barter_type": null,
  #                      "location": null,
  #                      "tags": [],
  #                      "id_book": null
  #                  }
  #              ]
  #          }
  #      }
  #      ```
  def reset_password
    user = User.find_by(reset_password_token: params[:token], email: params[:email])
    if(user.reset_password_sent_at > Time.now - 20.minutes)
      user.password = params[:password]
      user.reset_password_token = ""
      user.save!
      render json: user
    else
      render json: {error_code: Code[:error_resource], error_message: "token expired"}, status: Code[:status_error] 
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]  
  end
  
  # @url /user_preferred_location
  # @action POST
  #
  # set user preferred location
  #
  # @required [String] latitude Latitude coordinate
  # @required [String] longitude Longitude coordinate
  # @optional [String] country Country
  # @optional [String] state State
  # @optional [String] city City
  # @optional [String] name Name
  #
  # @response [Location] The created book
  #
  # @example_request_description Let's try to create a location
  # @example_request
  #    ```json
  #    {
  #      "latitude": "12.7777",
  #      "longitude": "12.34546",
  #    }
  #    ```
  # @example_response_description The location should be created correctly
  # @example_response
  #    ```json
  #    {
  #       "location": {
  #        "id": 17,
  #        "latitude": "12.7777",
  #        "longitude": "12.34546",
  #        "country": null,
  #        "city": null,
  #        "state": null,
  #        "address": null,
  #        "name": null,
  #        "id_location": "804f2bbb36fd58ee"
  #      }
  #    }
  #    ```
  def set_user_preferred_location
    location = current_user.set_preferred_location(params)
      if location
        render :json => location 
      else
        render :json => {error_code: Code[:error_resource], error_message: "location not created"}, status: Code[:status_error]
      end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end 

  # GET /prefered_location
  def get_user_preferred_location
    location = current_user.preferred_location
    if(location)
      render json: location
    else
      render json: {location: nil}
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end


  # @url /user_reviews
  # @action POST
  # 
  # post a review to the user
  #
  # @required [Integer] review_user_id review user id of users
  # @required [String] body review text
  # @example_request_description Let's create a user review
  # 
  # @example_request
  #    ```json
  #    {  
  #     review_user_id: hjghj67565
  #     body: "This user is good" 
  #     }
  #    ```
  # @example_response_description user_review_object
  # @example_response
  #    ```json
  #          {
  #            {
  #              "user_review": {
  #                  "review_user_id": "0cb8d9b007fb0f42",
  #                  "body": "this user is good",
  #                  "user_id": "e4afb1231b613376"
  #              }
  #          }
  #    }
  #    ```
  def set_user_review
    user_review = current_user.user_reviews.new
    review_user = User.find_by(id_user: params[:review_user_id])
    raise "Review user not present" if review_user.blank?
    user_review.review_user_id = review_user.id
    user_review.body = params[:body]
    if(user_review.save)
      render json: user_review, root: "user_reviews"
    else
      render json: user_review.errors, status: Code[:status_error]
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /user_reviews
  # @action GET
  # 
  # post a review to the user
  #
  # @required [String] user_id user_id guid of users
  # @example_request_description Let's get reviews of user
  # 
  # @example_request
  #    ```json
  #    {  
  #     user_id: hjghj67565    
  #     }
  #    ```
  # @example_response_description user_review_object
  # @example_response
  #    ```json
  #          {
  #            {
  #              {
  #                  "user_reviews": [
  #                      {
  #                          "review_user_id": "0cb8d9b007fb0f42",
  #                          "body": "this user is good",
  #                          "user_id": "e4afb1231b613376"
  #                      },
  #                          "review_user_id": "0cb8d9b007fb0f42",
  #                          "body": "this user is good",
  #                          "user_id": "e4afb1231b613376"
  #                      }
  #                  ]
  #              }
  #          }
  #    }
  #    ```
  def get_user_review
    user_reviews = UserReview.where(review_user_id: User.find_by(id_user: params[:user_id]))
    render json: user_reviews, root: "user_reviews"
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # POST /referral
  def register_referral
    User.register_referral(params[:referral_id], params[:device_id])
    render json: {}
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
 
  def generate_share_token
    token = current_user.generate_share_token
    render :json => {share_token: token}
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def get_share_token
    token = current_user.share_token 
    render :json => {share_token: token}
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def top_user_book_uploads
    user_book_array = Book.group(:user_id).count.sort_by{|key, values| values}.reverse
    # pending
  end

  # GET /current_user_referral_books
  def current_user_referral_books
    users_by_referral = current_user.referrals
    if users_by_referral.present?
      user_ids = users_by_referral.map{|u| u.id}
      book_count = Book.where(user_id: user_ids).count
      render json: {book_count: book_count}
    else
       render json: {book_count: ""}
    end
  end

 private
    def user_profile_params
      params[:user_profile] = JSON.parse(params[:user])
      if(params[:profile].present?)
        params[:user_profile][:user][:profile] = params[:profile]
      end
      params[:user_profile].require(:user).permit(:first_name, :last_name, :description, :email, :profile
      )
    end

end