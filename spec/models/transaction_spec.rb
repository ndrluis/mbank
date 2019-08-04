require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { is_expected.to define_enum_for(:kind).with_values(%w(transfer deposit)) }
end
