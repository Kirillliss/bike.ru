class RenameTableCharacteristicName < ActiveRecord::Migration
  def self.up
    rename_table :characteristic_name, :characteristic_names
  end

 def self.down
    rename_table :characteristic_names, :characteristic_name
 end
end
