class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :ref
      t.string :before
      t.string :after
      t.integer :repository_id
      t.text :message
      t.text :payload
      t.text :url
      t.string :author
      t.text :payload

      t.timestamps
    end
  end
end
