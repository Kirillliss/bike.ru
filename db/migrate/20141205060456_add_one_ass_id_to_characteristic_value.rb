class AddOneAssIdToCharacteristicValue < ActiveRecord::Migration
  def change
    add_column :characteristic_values, :one_ass_id, :string
  end
end
