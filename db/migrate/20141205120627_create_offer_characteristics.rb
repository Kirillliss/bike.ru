class CreateOfferCharacteristics < ActiveRecord::Migration
  def change
    create_table :offer_characteristics do |t|
      t.belongs_to :product_offer, index: true
      t.string :title
      t.string :value

      t.timestamps
    end
  end
end
