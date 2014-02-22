class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :full_name
      t.text :url
      t.integer :github_id
      t.integer :user_id
      t.string :hook_id

      t.timestamps
    end
  end
end
