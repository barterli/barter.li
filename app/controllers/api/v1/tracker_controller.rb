# @restful_api 1.0
#
# Issue or Feature Tracker
#
class Api::V1::TrackerController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :set_github, :create_feedback

  # @url /feedback
  # @action POST
  # 
  # bugs/feature report directly added to github issues
  #
  # @required [String] title title of bug/feature
  # @required [String] body body of bug/feature
  # @required [String] label label bug or feature
  # @example_request_description Let's create a feature suggestion
  # 
  # @example_request
  #    ```json
  #    {  
  #     title: "add book likes"
  #     body: "it would be better if u add book likes"
  #     label: "bug"
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #        {
  #         
  #    }
  #    ```
  def create_feedback
    check_param_fields
  	@result = @client.create_issue('barterli/barter.li', params[:title], params[:body], {:labels => params[:label] })
      save_feedback    
      Notifier.issue_tracker(current_user, @result.html_url).deliver
    render json: {status: :success}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def check_param_fields
    raise "Label cant be other than bug or features" unless params[:labels] == "bug" ||  params[:labels] == "features"
    raise "Body cant be blank" if params[:body].blank?
  end

  def save_feedback
    return if @result.blank?
    feedback = current_user.user_feedbacks.new
    feedback.message = params[:body]
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