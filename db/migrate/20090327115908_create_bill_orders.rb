class CreateBillOrders < ActiveRecord::Migration
  def self.up
    create_table :bill_orders do |t|
      t.references :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bill_orders
  end
end
