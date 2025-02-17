class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  private

  def authenticate_request
    api_key = request.headers['Trip-Api-Key']
    ak = ENV["API_KEY"]
    puts "Comparing API KEY with #{ak}"

    if api_key == ENV["API_KEY"] # Temporary. To be implemented with strong authentication in future.
      return
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
