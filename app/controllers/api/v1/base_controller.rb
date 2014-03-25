class Api::V1::BaseController < ApplicationController
  # skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token
  



end