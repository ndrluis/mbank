# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#balance' do
    it 'returns the sum of the account transactions' do
      source_account = create(:account)
      destination_account = create(:account)

      create(:deposit, destination: source_account, amount: 1000.00)

      create(
        :transfer,
        source_account: source_account,
        destination_account: destination_account,
        amount: 100.00
      )

      expect(destination_account.balance).to eq(100.00)
      expect(source_account.balance).to eq(900.00)
    end
  end

  describe '#enough_balance_to_transfer?' do
    let(:account) { create(:account) }

    context 'when negative balance' do
      it 'returns false' do
        expect(account.enough_balance_to_transfer?(100)).to be_falsey
      end
    end

    context 'when positive balance' do
      it 'returns true' do
        create(:deposit, destination: account, amount: 1000.00)

        expect(
          account.enough_balance_to_transfer?(200.00)
        ).to be_truthy
      end

      context 'with transaction amount greater than balance' do
        it 'returns false' do
          create(:deposit, destination: account, amount: 100.00)

          expect(
            account.enough_balance_to_transfer?(200.00)
          ).to be_falsey
        end
      end
    end
  end

  describe '#formatted_balance' do
    it 'returns the balance formatted with reais notation' do
      account = build_stubbed(:account)
      allow(account).to receive(:balance).and_return(1500.10)

      expect(account.formatted_balance).to eq('R$ 1.500,10')
    end
  end

  describe '#statements' do
    it 'returns the account statements' do
      source_account = create(:account)
      destination_account = create(:account)

      create(:deposit, destination: destination_account, amount: 100.00)

      create(:transfer,
             source_account: destination_account,
             destination_account: source_account, amount: 50)

      create(:deposit, destination: source_account, amount: 300)
      create(:transfer,
             source_account: source_account,
             destination_account: destination_account, amount: 150.50)

      create(:deposit, destination: source_account, amount: 25)

      expect(source_account.statements).to match(
        [
          {
            amount: 50.0,
            kind: 'transfer',
            balance: 50.0,
            source: destination_account,
            destination: source_account
          },
          {
            amount: 300.0,
            kind: 'deposit',
            balance: 350.0,
            source: source_account,
            destination: source_account
          },
          {
            amount: -150.50,
            kind: 'transfer',
            balance: 199.5,
            source: source_account,
            destination: destination_account
          },
          {
            amount: 25.0,
            kind: 'deposit',
            balance: 224.5,
            source: source_account,
            destination: source_account
          }
        ]
      )
    end
  end
end
