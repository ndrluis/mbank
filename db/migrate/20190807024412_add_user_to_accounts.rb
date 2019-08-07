# frozen_string_literal: true

class AddUserToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :user, foreign_key: true
  end
end
