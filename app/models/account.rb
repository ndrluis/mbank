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

  def statements
    current_balance = 0

    transactions.map do |transaction|
      amount = transaction.amount
      amount = -amount if transaction.debit_for?(self)
      current_balance += amount

      build_statement(amount, transaction, current_balance)
    end
  end

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

  def build_statement(amount, transaction, current_balance)
    {
      amount: amount.to_f,
      kind: transaction.kind,
      balance: current_balance.to_f,
      source: transaction.source_account,
      destination: transaction.destination_account
    }
  end

  def transactions
    debit_transfers
      .or(credit_transfers)
      .or(deposits)
  end

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
