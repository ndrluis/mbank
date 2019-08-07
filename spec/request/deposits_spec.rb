# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deposits', type: :request do
  describe 'POST /deposits' do
    let(:admin_user) { create(:user, role: :admin) }
    let(:destination_account) { create(:account) }
    let(:headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end

    context 'with valid params' do
      context 'when logged user role is admin' do
        before do
          auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, admin_user)

          post '/deposits', params: {
            deposit: {
              destination_account_id: destination_account.id,
              amount: 1000.55
            }
          }.to_json, headers: auth_headers
        end

        it 'returns 201 created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns deposit data' do
          expect(response_json).to include(
            'amount' => '1000.55',
            'kind' => 'deposit',
            'source_account_id' => destination_account.id,
            'destination_account_id' => destination_account.id
          )
        end
      end

      context 'when logged user role is client' do
        it 'returns 401 unauthorized' do
          auth_headers = Devise::JWT::TestHelpers.auth_headers(
            headers,
            destination_account.user
          )

          post '/deposits', params: {
            deposit: {
              destination_account_id: destination_account.id,
              amount: 1000.55
            }
          }.to_json, headers: auth_headers

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'with invalid params' do
      before do
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, admin_user)

        post '/deposits', params: {
          deposit: { destination_account_id: destination_account.id }
        }.to_json, headers: auth_headers
      end

      it 'returns 422 unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(response_json).to match(
          'amount' => ["can't be blank"]
        )
      end
    end
  end
end
