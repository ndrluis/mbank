# frozen_string_literal: true

module Accounts
  class BalancesController < ApplicationController
    def show
      account = Account.find(params[:account_id])

      if account
        render json: {
          balance: account.formatted_balance
        }, status: :ok
      else
        render json: { error: 'Record Not Found' }, status: :not_found
      end
    end
  end
end
