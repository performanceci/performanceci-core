class AddRepositoryConfigFields < ActiveRecord::Migration
  def change
    add_column :repositories, :repository_type, :string, default: 'github'
  end
end
