class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :avatar
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :job_title
      t.string :fb_url
      t.string :vk_url
      t.string :email
      t.integer :position
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
