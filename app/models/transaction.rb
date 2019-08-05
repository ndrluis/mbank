class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: "Account"
  belongs_to :destination_account, class_name: "Account"

  validates :amount, :kind, presence: true
  validate :enough_balance_to_transfer, if: :transfer?
  validate :transfer_to_destination, if: :transfer?

  enum kind: %w(transfer deposit)

  private

  def transfer_to_destination
    return if source_account_id != destination_account_id

    errors.add(:destination_account, "can't be the same of source account")
  end

  def enough_balance_to_transfer
    return if source_account.enough_balance_to_transfer?(amount)

    errors.add(:source_account, "doesn't have enough balance to transfer")
  end
end
