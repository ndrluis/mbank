# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  describe 'POST /accounts' do
    it 'returns 201 created' do
      post '/accounts'

      expect(response).to have_http_status(:created)
    end

    it 'returns account data' do
      post '/accounts'

      expect(response_json).to include(
        'id' => a_kind_of(Integer)
      )
    end
  end
end
