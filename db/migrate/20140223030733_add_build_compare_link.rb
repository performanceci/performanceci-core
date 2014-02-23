class AddBuildCompareLink < ActiveRecord::Migration
  def change
    add_column :builds, :compare, :text
  end
end
