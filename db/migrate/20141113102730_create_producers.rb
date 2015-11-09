class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.string :title

      t.timestamps
    end
  end
end
