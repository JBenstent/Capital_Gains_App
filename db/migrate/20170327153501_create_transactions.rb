class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :current_price
      t.string :ticker_symbol
      t.integer :quantity
      t.string :trade_price
      t.string :transaction_type
      t.timestamps null: false
    end
  end
end
