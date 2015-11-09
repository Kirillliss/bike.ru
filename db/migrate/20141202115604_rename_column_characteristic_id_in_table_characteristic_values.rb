class RenameColumnCharacteristicIdInTableCharacteristicValues < ActiveRecord::Migration
  def change
    rename_column :characteristic_values, :characteristic_id, :characteristic_name_id
    rename_column :through_product_characteristics, :characteristic_id, :characteristic_name_id
  end
end
