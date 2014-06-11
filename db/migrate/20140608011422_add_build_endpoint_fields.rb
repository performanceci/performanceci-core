class AddBuildEndpointFields < ActiveRecord::Migration
  def change
    add_column :endpoints, :duration, :integer

    add_column :build_endpoints, :full_results, :json
    add_column :build_endpoints, :status_codes, :json
    add_column :build_endpoints, :test_errors, :json
    add_column :build_endpoints, :request_count, :integer
  end
end
