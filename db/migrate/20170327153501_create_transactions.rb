class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :purchase_price
      t.string :ticker_symbol
      t.timestamps null: false
    end
  end
end
