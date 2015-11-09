class CreateAdminImports < ActiveRecord::Migration
  def change
    create_table :admin_imports do |t|
      t.string :file_xls
      t.timestamp :proccessed_at

      t.timestamps
    end
  end
end
