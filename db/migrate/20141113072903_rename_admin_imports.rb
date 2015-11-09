class RenameAdminImports < ActiveRecord::Migration
  def change
    rename_table :admin_imports, :imports
  end
end
