class ChangeIndexXmlAndOrdersXmlColumnTypes < ActiveRecord::Migration
  def change
    change_column :import_one_asses, :import_xml, :longtext
    change_column :import_one_asses, :offers_xml, :longtext
  end
end
