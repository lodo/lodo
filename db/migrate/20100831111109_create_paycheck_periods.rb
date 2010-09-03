class CreatePaycheckPeriods < ActiveRecord::Migration
  def self.up
    create_table :paycheck_periods do |t|
      t.integer :company_id
      t.integer :start_month
      t.integer :start_day
      t.integer :stop_month
      t.integer :stop_day
      t.integer :pay_month
      t.integer :pay_day

      t.timestamps
    end

    add_index :paycheck_periods,[:company_id], {:name => :paycheck_periods_comapny_idx}
    
  end

  def self.down
    drop_table :paycheck_periods
    remove_index :paycheck_periods, :paycheck_periods_comapny_idx
  end
end
