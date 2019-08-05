class TransfersController < ApplicationController
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
    transfer_params.merge(kind: :transfer)
  end

  def transfer_params
    params
      .require(:transfer)
      .permit(:source_account_id, :destination_account_id, :amount)
  end
end
