# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transfers', type: :request do
  describe 'POST /transfers' do
    let(:source_account) { Account.create }
    let(:destination_account) { Account.create }

    context 'with valid params' do
      context 'when source account has positive balance' do
        before do
          Transaction.create(
            destination_account: source_account,
            source_account: source_account,
            amount: 1000.00,
            kind: :deposit
          )
        end

        it 'returns 201 created' do
          post '/transfers', params: {
            transfer: {
              source_account_id: source_account.id,
              destination_account_id: destination_account.id,
              amount: 100
            }
          }

          expect(response).to have_http_status(:created)
        end

        it 'returns transaction information' do
          post '/transfers', params: {
            transfer: {
              source_account_id: source_account.id,
              destination_account_id: destination_account.id,
              amount: 100
            }
          }

          expect(response_json).to include(
            'amount' => '100.0',
            'kind' => 'transfer',
            'source_account_id' => source_account.id,
            'destination_account_id' => destination_account.id
          )
        end
      end

      context 'when source account does not has enough balance' do
        before do
          post '/transfers', params: {
            transfer: {
              source_account_id: source_account.id,
              destination_account_id: destination_account.id,
              amount: 100
            }
          }
        end

        it 'returns 422 unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          expect(response_json).to match(
            'source_account' => ["doesn't have enough balance to transfer"]
          )
        end
      end
    end

    context 'with invalid params' do
      before do
        post '/transfers', params: {
          transfer: {
            source_account_id: source_account.id,
            destination_account_id: destination_account.id
          }
        }
      end

      it 'returns 422 unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(response_json).to match(
          'amount' => ["can't be blank"],
          'source_account' => ["doesn't have enough balance to transfer"]
        )
      end
    end
  end
end
