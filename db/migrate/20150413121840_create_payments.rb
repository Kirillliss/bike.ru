class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.string :price
      t.string :state
      t.text :payload

      t.timestamps
    end
  end
end
