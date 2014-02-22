class AddEndpointOrder < ActiveRecord::Migration
  def change
      add_column :endpoints, :order, :integer
  end
end
