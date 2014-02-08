class Api::V1::BartersController < Api::V1::BaseController
  before_action :authenticate_user!


end