class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :price_from
      t.integer :price_to

      t.timestamps
    end
  end
end
