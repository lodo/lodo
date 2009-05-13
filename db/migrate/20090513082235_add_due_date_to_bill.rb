class AddDueDateToBill < ActiveRecord::Migration
  def self.up
    add_column :bills, :due_date, :datetime
  end

  def self.down
    remove_column :bills, :due_date
  end
end
