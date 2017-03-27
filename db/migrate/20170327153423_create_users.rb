class CreateUsers < ActiveRecord::Migration


  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.integer :checking_account
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :phone, :limit => 32
      t.timestamps null: false
    end
  end
end
