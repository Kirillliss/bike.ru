class CreateOfferPrices < ActiveRecord::Migration
  def change
    create_table :offer_prices do |t|
      t.belongs_to :product_offer, index: true
      t.string :one_ass_price_type_id
      t.float :price
      t.string :currency
      t.string :unit
      t.integer :coefficient

      t.timestamps
    end
  end
end
