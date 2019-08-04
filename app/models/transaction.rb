class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: "Account"
  belongs_to :destination_account, class_name: "Account"

  validates :amount, :kind, presence: true

  enum kind: %w(transfer deposit)
end
