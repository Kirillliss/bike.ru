class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :title
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
