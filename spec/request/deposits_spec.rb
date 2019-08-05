# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deposits', type: :request do
  describe 'POST /deposits' do
    context 'with valid params' do
      let(:account) { Account.create }

      it 'returns 201 created' do
        post '/deposits', params: {
          deposit: { destination_account_id: account.id, amount: 1000.50 }
        }

        expect(response).to have_http_status(:created)
      end

      it 'returns deposit data' do
        post '/deposits', params: {
          deposit: { destination_account_id: account.id, amount: 1000.55 }
        }

        expect(response_json).to include(
          'amount' => '1000.55',
          'kind' => 'deposit',
          'source_account_id' => account.id,
          'destination_account_id' => account.id
        )
      end
    end

    context 'with invalid params' do
      let(:account) { Account.create }

      it 'returns 422 unprocessable entity' do
        post '/deposits', params: {
          deposit: { destination_account_id: account.id }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        post '/deposits', params: {
          deposit: { destination_account_id: account.id }
        }

        expect(response_json).to match(
          'amount' => ["can't be blank"]
        )
      end
    end
  end
end
