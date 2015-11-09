class CreateImportCsvLines < ActiveRecord::Migration
  def change
    create_table :import_csv_lines do |t|
      t.string :article
      t.string :title
      t.string :size
      t.float :price
      t.integer :stock

      t.timestamps
    end
  end
end
