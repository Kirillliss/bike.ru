class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :title
      t.integer :amount
      t.boolean :all_products, default: false

      t.timestamps
    end
  end
end
