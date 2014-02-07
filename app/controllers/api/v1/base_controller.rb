class Api::V1::BaseController < ActionController::Base
  #skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token
  respond_to :json



end