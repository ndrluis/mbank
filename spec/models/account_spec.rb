# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#balance' do
    it 'returns the sum of the account transactions' do
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

  describe '#enough_balance_to_transfer?' do
    let(:account) { Account.create }

    context 'when negative balance' do
      it 'returns false' do
        expect(account.enough_balance_to_transfer?(100)).to be_falsey
      end
    end

    context 'when positive balance' do
      it 'returns true' do
        Transaction.create(
          destination_account: account,
          source_account: account,
          amount: 1000.00,
          kind: :deposit
        )

        expect(
          account.enough_balance_to_transfer?(200.00)
        ).to be_truthy
      end

      context 'with transaction amount greater than balance' do
        it 'returns false' do
          Transaction.create(
            destination_account: account,
            source_account: account,
            amount: 100.00,
            kind: :deposit
          )

          expect(
            account.enough_balance_to_transfer?(200.00)
          ).to be_falsey
        end
      end
    end
  end

  describe '#formatted_balance' do
    it 'returns the balance formatted with reais notation' do
      account = Account.new
      allow(account).to receive(:balance).and_return(1500.10)

      expect(account.formatted_balance).to eq('R$ 1.500,10')
    end
  end
end
