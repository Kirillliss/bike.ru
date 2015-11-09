class AddOneAssColumnToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :one_ass_id, :string
    add_column :categories, :last_oneassed_at, :timestamp
  end
end
