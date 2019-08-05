# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :source_account, references: :accounts, foreign_key: {
        to_table: :accounts
      }
      t.references :destination_account, references: :accounts, foreign_key: {
        to_table: :accounts
      }
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
