class CreateBuildEndpoints < ActiveRecord::Migration
  def change
    create_table :build_endpoints do |t|
      t.integer :endpoint_id
      t.integer :build_id
      t.text :data
      t.float :response_time
      t.integer :score
      t.text :screenshot

      t.timestamps
    end
  end
end
