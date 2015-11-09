class AddImportTextToImportOneAsses < ActiveRecord::Migration
  def change
    add_column :import_one_asses, :import_xml, :text
    add_column :import_one_asses, :offers_xml, :text
  end
end
