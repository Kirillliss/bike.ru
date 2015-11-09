class CreateProductCharacteristics < ActiveRecord::Migration
  def change
    create_table :product_characteristics do |t|
      t.belongs_to :product, index: true
      t.belongs_to :characteristic_name, index: true
      t.belongs_to :characteristic_value, index: true

      t.timestamps
    end
  end
end
