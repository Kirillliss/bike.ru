class CreateCharacteristicsGroups < ActiveRecord::Migration
  def change
    create_table :characteristics_groups do |t|
      t.string :title

      t.timestamps
    end
  end
end
