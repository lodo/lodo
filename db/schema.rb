# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090402115322) do

  create_table "accounts", :force => true do |t|
    t.integer  "number",         :null => false
    t.string   "name",           :null => false
    t.integer  "company_id"
    t.integer  "activatable_id"
    t.string   "lodo_name",      :null => false
    t.string   "debit_text",     :null => false
    t.string   "credit_text",    :null => false
    t.string   "comments",       :null => false
    t.boolean  "has_ledger",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activatables", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_periods", :force => true do |t|
    t.integer  "start"
    t.integer  "stop"
    t.integer  "activatable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "street1"
    t.string   "street2"
    t.string   "postal_code"
    t.string   "town"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_items", :force => true do |t|
    t.integer  "order_item_id"
    t.integer  "amount"
    t.decimal  "price",         :precision => 20, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_order_id"
  end

  create_table "bill_orders", :force => true do |t|
    t.integer  "bill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price"
    t.integer  "order_id"
  end

  create_table "bills", :force => true do |t|
    t.date     "delivery_date"
    t.date     "billing_date"
    t.integer  "company_id"
    t.decimal  "price",         :precision => 20, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "organization_number"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies_users", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "user_id"
  end

  create_table "journal_operations", :force => true do |t|
    t.integer  "journal_id"
    t.integer  "account_id"
    t.decimal  "amount",     :precision => 20, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journals", :force => true do |t|
    t.integer  "journal_type"
    t.integer  "number"
    t.date     "journal_date"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ledgers", :force => true do |t|
    t.string   "name",                :null => false
    t.integer  "account_id",          :null => false
    t.integer  "number",              :null => false
    t.integer  "account_type_id"
    t.integer  "address_id"
    t.string   "telephone_number"
    t.string   "mobile_number"
    t.string   "email"
    t.string   "comment"
    t.boolean  "placement_top"
    t.string   "customer_number"
    t.string   "ledger_bank_number"
    t.string   "foreign_bank_number"
    t.string   "debit_text",          :null => false
    t.string   "credit_text",         :null => false
    t.integer  "unit_id"
    t.integer  "project_id"
    t.integer  "credit_days"
    t.boolean  "auto_payment"
    t.boolean  "net_bank"
    t.integer  "result_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.decimal  "price",      :precision => 20, :scale => 2
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billed",                                    :default => 0
  end

  create_table "orders", :force => true do |t|
    t.decimal  "price",                   :precision => 20, :scale => 2
    t.integer  "mva"
    t.date     "order_date"
    t.date     "requested_delivery_date"
    t.integer  "seller_id"
    t.integer  "customer_id"
    t.integer  "delivery_address_id"
    t.integer  "transport_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.decimal  "price",      :precision => 20, :scale => 2
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "address_id"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "address_id"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "hashed_password"
    t.string   "email"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_company"
  end

end
