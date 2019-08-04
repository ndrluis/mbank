class Account < ApplicationRecord
  has_many :debit_transfers,
    -> { Transaction.transfer },
    foreign_key: "source_account_id",
    class_name: "Transaction"

  has_many :credit_transfers,
    -> { Transaction.transfer },
    foreign_key: "destination_account_id",
    class_name: "Transaction"

  has_many :deposits,
    -> { Transaction.deposit },
    foreign_key: "source_account_id",
    class_name: "Transaction"

  def balance
    deposits_balance +
      credit_transfers_balance -
      debit_transfers_balance
  end

  private

  def credit_transfers_balance
    credit_transfers.sum(:amount)
  end

  def debit_transfers_balance
    debit_transfers.sum(:amount)
  end

  def deposits_balance
    deposits.sum(:amount)
  end
end
