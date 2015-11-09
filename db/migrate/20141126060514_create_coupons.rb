class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.belongs_to :user, index: true
      t.integer :amount
      t.string :code
      t.timestamp :valid_till
      t.boolean :permanent, default: false
      t.belongs_to :cart, index: true
      t.timestamp :used_at
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
