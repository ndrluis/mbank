# frozen_string_literal: true

module Accounts
  class BalancesController < ApplicationController
    before_action :authenticate_user!

    def show
      account = current_user.accounts.find(params[:account_id])

      render json: {
        balance: account.formatted_balance
      }, status: :ok
    end
  end
end
