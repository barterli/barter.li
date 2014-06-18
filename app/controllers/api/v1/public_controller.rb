# @restful_api 1.0
#
# Public Controller
#
class Api::V1::PublicController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:register]
	
  def index


  end


   def welcome
     if stale?(:etag => 'welcome page', :last_modified => Code[:etag_last_modified], :public => true)
       @register = Register.new
       render layout: "welcome"
     end
   end

  # @url /register
  # @action POST
  # 
  # register yourself with barter.li
  #
  # @required [String] message  a small description
  # @required [String] register_type  as [campus_ambassador, designer,developer, sponsor, volunteer]
  # 
  # @example_request
  #    ```json
  #    {  
  #     message: "sample message"
  #     register_type: "designer"
  #     }
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #         
  #    }
  #    ```
  def register
    @register = Register.new
    @register.email = current_user.email
    @register.body = params[:message]
    @register.register_type = params[:register_type]
    if(@register.save)
    	render json: {status: :success}
    else
      render json: {status: :error}
    end 
  end


  def version
    version = Version.where(current: true, code_type: params[:code_type]).last
    if(version.code > params[:code])
      render json: {status: false}
    else
      render json: {status: true}
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # GET /default
  def default
    render json: {error: "no route matches"}
  end


  # @url /tribute
  # @action GET
  # 
  # Tribute page for Aaron Swartz.( this is for input in admin panel# params: body (hash {message: "", image_url:""})
  # params: page_name (should be tribute))
  #
  # 
  # @example_request_description Let's send a request
  # 
  # @example_request
  #    ```json
  #    {  
  #     
  #     }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #         {
  #            "tribute": {
  #             "message": "A Tribute to Aaron Swartz for inspiring us with his passion",
  #             "image_url": "http://162.243.198.171/uploads/static/image/2/barterli.jpg"
  #              }
  #           }
  #    }
  #    ```
  def tribute
    tribute_page = Static.find_by(page_name: "tribute")
    tribute = tribute_page.body
    tribute.merge!(image_url: "http://"+request.host_with_port+tribute_page.image.url) if tribute_page.image.present?
#    if stale?(:etag => 'tribute page', :last_modified => tribute.updated_at , :public => true)
      render json: {tribute: tribute}
    # end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # @url /team
  # @action GET
  # 
  # Team members.( this is for input in admin panel# params: body (hash {name: "", email:"", image_url:""})
  # params: page_name (should be team))
  #
  # 
  # @example_request_description Let's send a request
  # 
  # @example_request
  #    ```json
  #    {  
  #     
  #     }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #            {
  #                "team": [
  #                    {
  #                        "name": "Anshul",
  #                        "email": "test@gmail.com",
  #                        "image_url": "http://162.243.198.171/uploads/static/image/3/963a642ba92bf255657bf60dacd92dcc.jpeg"
  #                    }
  #                ]
  #            }
  #    }
  #    ```
  def team
    team_page = Static.where(page_name: "team").order("row_order ASC")
    team = team_page.map{|t| t.image.present? ? t.body.merge(image_url: "http://"+request.host_with_port+ActionController::Base.helpers.asset_path(t.image.url)) : t.body}
    # if stale?(:etag => 'team page member', :last_modified => team_page.maximum(:updated_at) , :public => true)
      render json: {team: team}
    # end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
 
   def collaborate
     if stale?(:etag => 'Collabarate', :last_modified => Code[:etag_last_modified], :public => true)
       render layout: "welcome"
     end
   end

end
