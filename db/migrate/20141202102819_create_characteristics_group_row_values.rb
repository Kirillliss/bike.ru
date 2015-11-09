class CreateCharacteristicsGroupRowValues < ActiveRecord::Migration
  def change
    create_table :characteristics_group_vls do |t|
      t.belongs_to :characteristics_group_row, index: true
      t.belongs_to :characteristic_value, index: true

      t.timestamps
    end
  end
end
