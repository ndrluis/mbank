# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { is_expected.to define_enum_for(:kind).with_values(%w[transfer deposit]) }

  describe 'validations' do
    describe '#transfer_to_destination' do
      context 'when transaction kind is transfer' do
        context 'when source and destination account is the same' do
          it 'adds error message' do
            account = create(:account)

            Transaction.create(
              source_account: account,
              destination_account: account,
              amount: 110.50,
              kind: :deposit
            )

            transaction = Transaction.new(
              source_account: account,
              destination_account: account,
              amount: 110.50,
              kind: :transfer
            )

            transaction.valid?

            expect(transaction.errors.messages).to eq(
              destination_account: ["can't be the same of source account"]
            )
          end
        end

        context 'when source and destination account is different' do
          it 'does not add error message' do
            source_account = create(:account)
            destination_account = create(:account)

            Transaction.create(
              source_account: source_account,
              destination_account: source_account,
              amount: 110.50,
              kind: :deposit
            )

            transaction = Transaction.new(
              source_account: source_account,
              destination_account: destination_account,
              amount: 110.50,
              kind: :transfer
            )

            transaction.valid?

            expect(transaction.errors).to be_empty
          end
        end
      end

      context 'when transaction kind is deposit' do
        it 'does not add error message' do
          source_account = create(:account)

          transaction = Transaction.new(
            source_account: source_account,
            destination_account: source_account,
            amount: 110.50,
            kind: :deposit
          )

          transaction.valid?

          expect(transaction.errors).to be_empty
        end
      end
    end

    describe '#enough_balance_to_transfer' do
      context 'when transation kind is transfer' do
        context 'with transfer amount greater than balance' do
          it 'does not add error message' do
            source_account = create(:account)
            destination_account = create(:account)

            Transaction.create(
              source_account: source_account,
              destination_account: source_account,
              amount: 110.50,
              kind: :deposit
            )

            transaction = Transaction.new(
              source_account: source_account,
              destination_account: destination_account,
              amount: 100.50,
              kind: :transfer
            )

            transaction.valid?

            expect(transaction.errors).to be_empty
          end
        end

        context 'with transfer amount lower than balance' do
          it 'adds error message' do
            source_account = create(:account)
            destination_account = create(:account)

            transaction = Transaction.new(
              source_account: source_account,
              destination_account: destination_account,
              amount: 100.50,
              kind: :transfer
            )

            transaction.valid?

            expect(transaction.errors.messages).to eq(
              source_account: ["doesn't have enough balance to transfer"]
            )
          end
        end

        context 'when transation kind is deposit' do
          it 'skips the validation' do
            account = create(:account)

            transaction = Transaction.new(
              source_account: account,
              destination_account: account,
              amount: 100.50,
              kind: :deposit
            )

            expect(transaction).to be_valid
          end
        end
      end
    end
  end
end
