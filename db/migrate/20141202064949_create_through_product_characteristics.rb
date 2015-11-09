class CreateThroughProductCharacteristics < ActiveRecord::Migration
  def change
    create_table :through_product_characteristics do |t|
      t.belongs_to :product, index: true
      t.belongs_to :characteristic, index: true

      t.timestamps
    end
  end
end
