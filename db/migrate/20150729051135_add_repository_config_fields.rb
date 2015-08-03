class AddRepositoryConfigFields < ActiveRecord::Migration
  def change
    add_column :repositories, :repository_type, :string, default: 'github'
    add_column :repositories, :config, :text
  end
end
