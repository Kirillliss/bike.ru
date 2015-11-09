class AddCharacteristicsGroupToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :characteristics_group, index: true
  end
end
