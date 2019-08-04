require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "#balance" do
    it "returns the sum of the account transactions" do
      source_account = Account.create
      destination_account = Account.create

      Transaction.create(
        destination_account: source_account,
        source_account: source_account,
        amount: 1000.00,
        kind: :deposit
      )

      Transaction.create(
        source_account: source_account,
        destination_account: destination_account,
        amount: 100.00,
        kind: :transfer
      )

      expect(destination_account.balance).to eq(100.00)
      expect(source_account.balance).to eq(900.00)
    end
  end
end
