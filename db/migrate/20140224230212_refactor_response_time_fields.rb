class RefactorResponseTimeFields < ActiveRecord::Migration
  def change
    remove_column :endpoints, :max_response_time
    remove_column :endpoints, :warn_response_time
    add_column :endpoints, :max_response_time, :float
    add_column :endpoints, :target_response_time, :float
  end
end
