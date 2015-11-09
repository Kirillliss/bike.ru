class AddBarcodeToImportCsvLines < ActiveRecord::Migration
  def change
    add_column :import_csv_lines, :barcode, :string
  end
end
