class CreateSpecialOffers < ActiveRecord::Migration
  def change
    create_table :special_offers do |t|
      t.belongs_to :product_one, index: true
      t.belongs_to :product_two, index: true
      t.float :special_price
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
