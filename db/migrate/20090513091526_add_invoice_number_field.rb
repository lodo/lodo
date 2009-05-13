class AddInvoiceNumberField < ActiveRecord::Migration
  def self.up
    add_column :companies, :next_invoice_number, :integer, :null => false, :default => 1000
    add_column :bills, :invoice_number, :integer, :null => :true
  end

  def self.down
    remove_column :companies, :next_invoice_number
    remove_column :bills, :invoice_number
  end
end
