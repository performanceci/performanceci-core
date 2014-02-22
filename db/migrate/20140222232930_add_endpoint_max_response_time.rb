class AddEndpointMaxResponseTime < ActiveRecord::Migration
  def change
    add_column :endpoints, :max_response_time, :integer
  end
end
