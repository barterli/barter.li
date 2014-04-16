class Api::V1::TrackerController < Api::V1::BaseController
  #before_action :authenticate_user!
  before_action :set_github
  
  def create_feedback
	result = @client.create_issue('barterli/barter.li', params[:title], params[:body], {:labels => params[:label] })
	if(current_user.present?)
    link = "https://github.com/barterli/barter.li/issues?state=open"
    Notifier.issue_tracker(current_user, link).deliver
  end
  render json: {status: :success}
  rescue
  	render json: {status: :error}
  end



  private
    def set_github
     @client = Octokit::Client.new :login => "#{ENV['GITHUB_USERNAME']}", :password => "#{ENV['GITHUB_PASSWORD']}"
    end
end