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
            create(:deposit, destination: account)

            transaction = build(
              :transfer, source_account: account, destination_account: account
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

            create(:deposit, destination: source_account)

            transaction = build(
              :transfer,
              source_account: source_account,
              destination_account: destination_account
            )

            transaction.valid?

            expect(transaction.errors).to be_empty
          end
        end
      end

      context 'when transaction kind is deposit' do
        it 'does not add error message' do
          account = create(:account)
          transaction = build(:deposit, destination: account)

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

            create(:deposit, destination: source_account)

            transaction = build(
              :transfer,
              source_account: source_account,
              destination_account: destination_account
            )

            transaction.valid?

            expect(transaction.errors).to be_empty
          end
        end

        context 'with transfer amount lower than balance' do
          it 'adds error message' do
            source_account = create(:account)
            destination_account = create(:account)

            transaction = build(
              :transfer,
              source_account: source_account,
              destination_account: destination_account
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
            transaction = build(:deposit, destination: account)

            expect(transaction).to be_valid
          end
        end
      end
    end
  end

  describe '#debit_for?' do
    context 'when transaction kind is transfer' do
      context 'when received account is the source account' do
        it 'returns true' do
          account = create(:account)
          create(:deposit, destination: account)
          transfer = create(:transfer, source_account: account)

          expect(
            transfer.debit_for?(account)
          ).to be(true)
        end

        context 'when received account is not the source account' do
          it 'returns false' do
            account = create(:account)
            another_account = create(:account)
            create(:deposit, destination: account)
            transfer = create(:transfer, source_account: account)

            expect(
              transfer.debit_for?(another_account)
            ).to be(false)
          end
        end
      end

      context 'when transaction kind is deposit' do
        it 'returns false' do
          account = create(:account)
          deposit = create(:deposit, destination: account)

          expect(deposit.debit_for?(account)).to be(false)
        end
      end
    end
  end
end
