class Api::V1::TrackerController < Api::V1::BaseController
  #before_action :authenticate_user!
  before_action :set_github, :create_feedback
  
  def create_feedback
	@result = @client.create_issue('barterli/barter.li', params[:title], params[:body], {:labels => params[:label] })
    save_feedback    
    Notifier.issue_tracker(current_user, @result.html_url).deliver
  render json: {status: :success}
  rescue
  	render json: {status: :error}
  end

  def save_feedback
    return if @result.blank?
    feedback = current_user.user_feedbacks.new
    feedback.message = params[:message]
    feedback.title = params[:title]
    feedback.issue_id = @result.number 
    feedback.issue_url = @result.html_url
    feedback.label = params[:label]
  end

  private
    def set_github
     @client = Octokit::Client.new :login => "#{ENV['GITHUB_USERNAME']}", :password => "#{ENV['GITHUB_PASSWORD']}"
    end
end