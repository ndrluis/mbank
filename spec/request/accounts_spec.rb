# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  let(:user) { create(:user) }

  let(:headers) do
    headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }

    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  describe 'POST /accounts' do
    it 'returns 201 created' do
      post '/accounts', headers: headers

      expect(response).to have_http_status(:created)
    end

    it 'returns account data' do
      post '/accounts', headers: headers

      expect(response_json).to include(
        'id' => a_kind_of(Integer)
      )
    end
  end
end
