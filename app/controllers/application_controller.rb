# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    render json: {
      error: "Couldn't find #{exception.model} with id #{exception.id}"
    }, status: :not_found
  end

  def render_errors(errors)
    render json: {
      errors: errors
    }, status: :unprocessable_entity
  end
end
