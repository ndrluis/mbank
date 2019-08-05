# frozen_string_literal: true

class DepositsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    deposit_params.merge(
      source_account_id: deposit_params[:destination_account_id],
      kind: :deposit
    )
  end

  def deposit_params
    params
      .require(:deposit)
      .permit(:destination_account_id, :amount)
  end
end
