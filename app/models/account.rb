# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :debit_transfers,
           -> { Transaction.transfer },
           foreign_key: 'source_account_id',
           class_name: 'Transaction'

  has_many :credit_transfers,
           -> { Transaction.transfer },
           foreign_key: 'destination_account_id',
           class_name: 'Transaction'

  has_many :deposits,
           -> { Transaction.deposit },
           foreign_key: 'source_account_id',
           class_name: 'Transaction'

  belongs_to :user

  def balance
    deposits_balance +
      credit_transfers_balance -
      debit_transfers_balance
  end

  def enough_balance_to_transfer?(amount)
    return unless balance.positive?

    !(balance - amount).negative?
  end

  def formatted_balance
    ActiveSupport::NumberHelper.number_to_currency(
      balance, locale: :'pt-BR'
    )
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
