class ApplicationController < ActionController::API
  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    render json: { error: exception.message }, status: 404
  end
end
