class AddPaycheckIndex < ActiveRecord::Migration
  def self.up
    add_index :paycheck_lines, :paycheck_id, {:name => 'paycheck_lines_paycheck_idx'}
  end

  def self.down
    remove_index :paycheck_lines, 'paycheck_lines_paycheck_idx'
  end
end
