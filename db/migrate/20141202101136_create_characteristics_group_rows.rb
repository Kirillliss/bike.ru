class CreateCharacteristicsGroupRows < ActiveRecord::Migration
  def change
    create_table :characteristics_group_rows do |t|
      t.belongs_to :characteristics_group, index: true
      t.belongs_to :characteristic_name, index: true

      t.timestamps
    end
  end
end
