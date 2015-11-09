class CreateImportOneAsses < ActiveRecord::Migration
  def change
    create_table :import_one_asses do |t|
      t.string :offers
      t.string :import

      t.timestamps
    end
  end
end
