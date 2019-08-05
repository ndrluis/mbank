# frozen_string_literal: true

module ResponseJSON
  def response_json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ResponseJSON, type: :request
end
