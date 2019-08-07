# frozen_string_literal: true

class TransfersController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.accounts.find(transfer_params[:source_account_id])
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render json: transaction, status: :created
    else
      render_errors(transaction.errors)
    end
  end

  private

  def transaction_params
    transfer_params.merge(kind: :transfer)
  end

  def transfer_params
    params
      .require(:transfer)
      .permit(:source_account_id, :destination_account_id, :amount)
  end
end
