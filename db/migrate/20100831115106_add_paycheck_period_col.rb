class AddPaycheckPeriodCol < ActiveRecord::Migration
  def self.up
    add_column :paychecks, :paycheck_period_id, :integer
    add_index :paychecks, :paycheck_period_id, {:name => :paychecks_paycheck_period_idx}
  end

  def self.down
    remove_column :paychecks, :paycheck_period_id
    remove_index :paycheck_periods, :paychecks_paycheck_period_idx
  end
end
