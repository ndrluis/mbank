# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts Balances', type: :request do
  describe 'GET /accounts/:account_id/balance' do
    let(:user) do
      User.create(email: 'foo@bar', password: '123456')
    end

    let(:headers) do
      { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    end

    let(:auth_headers) do
      Devise::JWT::TestHelpers.auth_headers(headers, user)
    end

    context 'with invalid params' do
      it 'returns 404 not found' do
        get '/accounts/12341/balance', headers: auth_headers

        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        get '/accounts/12341/balance', headers: auth_headers

        expect(response_json).to eq(
          'error' => "Couldn't find Account with id 12341"
        )
      end
    end

    context 'with valid params' do
      it 'returns the formatted balance' do
        account = Account.create(user: user)

        Transaction.create(
          source_account: account,
          destination_account: account,
          amount: 110.50,
          kind: :deposit
        )

        get "/accounts/#{account.id}/balance", headers: auth_headers

        expect(response_json).to eq(
          'balance' => 'R$ 110,50'
        )
      end
    end
  end
end
