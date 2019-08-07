# frozen_string_literal: true

FactoryBot.define do
  factory :deposit, class: Transaction do
    transient do
      destination { build(:account) }
    end

    association :source_account, factory: :account
    association :destination_account, factory: :account
    amount { 100.00 }
    kind { 'deposit' }

    after(:build) do |transaction, evaluator|
      transaction.source_account = evaluator.destination
      transaction.destination_account = evaluator.destination
    end
  end

  factory :transfer, class: Transaction do
    association :source_account, factory: :account
    association :destination_account, factory: :account
    amount { 100.00 }
    kind { 'transfer' }
  end
end
