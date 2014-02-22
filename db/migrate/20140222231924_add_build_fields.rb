class AddBuildFields < ActiveRecord::Migration
  def change
    add_column :builds, :build_status, :string
    add_column :builds, :docker_image_id, :string
    add_column :builds, :docker_container_id, :string
  end
end
