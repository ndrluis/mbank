# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def create
    account = current_user.accounts.create

    render json: account, status: :created
  end
end
