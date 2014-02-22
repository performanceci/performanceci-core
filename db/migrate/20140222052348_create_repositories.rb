class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.text :url
      t.integer :github_id

      t.timestamps
    end
  end
end
