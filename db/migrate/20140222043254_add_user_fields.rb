class AddUserFields < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :github_id, :string
    add_column :users , :github_oauth_token , :string
    add_column :users , :gravatar_id , :string
  end
end
