class AddExternalToken < ActiveRecord::Migration
  def change
    add_column :repositories, :build_token, :string
  end
end
