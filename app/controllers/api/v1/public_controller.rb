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

  # POST /register
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

  def default
    render json: {error: "no route matches"}
  end

  # GET /tribute
  # params: body (hash {message: "", image_url:""})
  # params: page_name (should be tribute)
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



  # GET /team
  # params: body (hash {name: "", image_url:"", email:"", description:""})
  # params: page_name (should be team)
  def team
    team_page = Static.where(page_name: "team")
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
