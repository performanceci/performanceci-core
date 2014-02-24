class AddStatusFields < ActiveRecord::Migration
  def up
    add_column :build_endpoints, :status, :string
    add_column :endpoints, :warn_response_time, :float
    add_column :repositories, :status, :string
    add_column :builds, :status, :string
    add_column :builds, :average_response, :float
    add_column :builds, :percent_change, :float, default: 0
  end

  def down
    remove_column :build_endpoints, :status
    remove_column :endpoints, :warn_response_time
    remove_column :repositories, :status
    remove_column :builds, :status

    remove_column :builds, :average_response
    remove_column :builds, :percent_change

  end

end
