class AddProjectIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :project_id, :integer
  end

  def self.down
    remove_column :orders, :project_id
  end
end
