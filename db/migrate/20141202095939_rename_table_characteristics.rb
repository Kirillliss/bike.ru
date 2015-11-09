class RenameTableCharacteristics < ActiveRecord::Migration
  def self.up
    rename_table :characteristics, :characteristic_name
  end

 def self.down
    rename_table :characteristic_name, :characteristics
 end
end
