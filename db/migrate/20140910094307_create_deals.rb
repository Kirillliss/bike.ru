class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title
      t.boolean :published, default: false
      t.string :image
      t.string :description

      t.timestamps
    end
  end
end
