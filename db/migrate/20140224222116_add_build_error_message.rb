class AddBuildErrorMessage < ActiveRecord::Migration
  def change
    add_column :builds, :error_message, :text
  end
end
