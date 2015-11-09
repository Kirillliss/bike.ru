class CreateProductOffers < ActiveRecord::Migration
  def change
    create_table :product_offers do |t|
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end
