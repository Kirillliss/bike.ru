class CreatePageProjects < ActiveRecord::Migration
  def change
    create_table :page_projects do |t|
      t.belongs_to :page, index: true
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
