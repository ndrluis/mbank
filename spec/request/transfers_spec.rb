# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transfers', type: :request do
  describe 'POST /transfers' do
    let(:source_user) do
      User.create(email: 'foo@bar', password: '123456')
    end

    let(:source_account) { Account.create(user: source_user) }

    let(:destination_account) do
      user = User.create(email: 'foo2@bar', password: '123456')
      Account.create(user: user)
    end

    let(:headers) do
      { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    end

    let(:auth_headers) do
      Devise::JWT::TestHelpers.auth_headers(headers, source_user)
    end

    context 'with valid params' do
      context 'when source account has positive balance' do
        before do
          Transaction.create(
            destination_account: source_account,
            source_account: source_account,
            amount: 1000.00,
            kind: :deposit
          )

          post '/transfers', params: {
            transfer: {
              source_account_id: source_account.id,
              destination_account_id: destination_account.id,
              amount: 100
            }
          }.to_json, headers: auth_headers
        end

        it 'returns 201 created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns transfer data' do
          expect(response_json).to include(
            'amount' => '100.0',
            'kind' => 'transfer',
            'source_account_id' => source_account.id,
            'destination_account_id' => destination_account.id
          )
        end
      end

      context 'when user transfer with a source account that does not exists' do
        before do
          post '/transfers', params: {
            transfer: {
              source_account_id: 999,
              destination_account_id: destination_account.id,
              amount: 100
            }
          }.to_json, headers: auth_headers
        end

        it 'returns 404 not found' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(response_json).to eq(
            'error' => "Couldn't find Account with id 999"
          )
        end
      end

      context 'when source account does not have enough balance' do
        before do
          post '/transfers', params: {
            transfer: {
              source_account_id: source_account.id,
              destination_account_id: destination_account.id,
              amount: 100
            }
          }.to_json, headers: auth_headers
        end

        it 'returns 422 unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          expect(response_json['errors']).to match(
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
        }.to_json, headers: auth_headers
      end

      it 'returns 422 unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(response_json['errors']).to match(
          'amount' => ["can't be blank"],
          'source_account' => ["doesn't have enough balance to transfer"]
        )
      end
    end
  end
end
