class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :title
      t.string :code
      t.text :body

      t.timestamps
    end
  end
end
