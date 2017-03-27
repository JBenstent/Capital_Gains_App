class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.references :user, index: true, foreign_key: true
      t.string :ticker_symbol

      t.timestamps null: false
    end
  end
end
