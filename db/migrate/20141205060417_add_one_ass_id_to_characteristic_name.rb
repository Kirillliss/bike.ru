class AddOneAssIdToCharacteristicName < ActiveRecord::Migration
  def change
    add_column :characteristic_names, :one_ass_id, :string
  end
end
