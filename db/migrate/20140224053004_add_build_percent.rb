class AddBuildPercent < ActiveRecord::Migration
  def change
    add_column :builds, :percent_done, :integer, default: 0
  end
end
