# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.save

    if resource.save
      render json: resource
    else
      render_errors(resource.errors)
    end
  end
end
