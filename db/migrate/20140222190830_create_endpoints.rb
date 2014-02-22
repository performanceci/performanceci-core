class CreateEndpoints < ActiveRecord::Migration
  def change
    create_table :endpoints do |t|
      t.string :name
      t.text :url
      t.text :headers
      t.integer :repository_id
      t.string :benchmark_type
      t.integer :request_count
      t.integer :concurrency

      t.timestamps
    end
  end
end
