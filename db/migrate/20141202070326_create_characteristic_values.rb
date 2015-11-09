class CreateCharacteristicValues < ActiveRecord::Migration
  def change
    create_table :characteristic_values do |t|
      t.string :value
      t.belongs_to :characteristic, index: true

      t.timestamps
    end
  end
end
