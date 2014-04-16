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

  def tribute
    tribute = Static.find_by(page_name: "tribute")
#    if stale?(:etag => 'tribute page', :last_modified => tribute.updated_at , :public => true)
      render json: {tribute: tribute.body}
    # end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def team
    team_page = Static.where(page_name: "team")
    team = team_page.map{|t| t.body}
    if stale?(:etag => 'team page member', :last_modified => team_page.maximum(:updated_at) , :public => true)
      render json: {team: team}
    end
  rescue => e
    render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
 
   def collaborate
     if stale?(:etag => 'Collabarate', :last_modified => Code[:etag_last_modified], :public => true)
       render layout: "welcome"
     end
   end

end
