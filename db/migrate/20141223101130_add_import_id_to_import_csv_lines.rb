class AddImportIdToImportCsvLines < ActiveRecord::Migration
  def change
    add_reference :import_csv_lines, :import, index: true
  end
end
