class AddPaycheckPeriod < ActiveRecord::Migration
  def self.up
    create_table :paycheck_periods do |t|
      t.integer :start_month
      t.integer :start_day

      t.integer :stop_month
      t.integer :stop_day

      t.integer :pay_month
      t.integer :pay_day

      t.integer :company_id
    end
  end

  def self.down
    drop_table :paycheck_periods
  end

end
