class CreateLineItemCharacteristics < ActiveRecord::Migration
  def change
    create_table :line_item_characteristics do |t|
      t.belongs_to :characteristic_name, index: true
      t.belongs_to :characteristic_value, index: true
      t.belongs_to :line_item, index: true

      t.timestamps
    end
  end
end
