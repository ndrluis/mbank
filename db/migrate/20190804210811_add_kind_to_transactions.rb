class AddKindToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :kind, :integer
  end
end
