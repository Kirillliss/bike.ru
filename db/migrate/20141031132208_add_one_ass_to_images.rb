class AddOneAssToImages < ActiveRecord::Migration
  def change
    add_column :images, :one_ass_path, :string
  end
end
