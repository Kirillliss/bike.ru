class CreateTizers < ActiveRecord::Migration
  def change
    create_table :tizers do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
