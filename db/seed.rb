puts "Seeding db.."
ActiveRecord::Base.transaction do

Role.create!(:name => "user") if Role.find_by_name("user").nil?
Role.create!(:name => "accountant") if Role.find_by_name("accountant").nil?
Role.create!(:name => "employee") if Role.find_by_name("employee").nil?

# load tax rate data for 2010
if TaxRate.find(:first, :conditions => {:year => 2010}).nil?
  puts "importing 2010 tax rates"
  `cp "#{Rails.root}/db/skattetrekk2010.txt" "/tmp/trekk2010.txt"`
  TaxRate.connection.execute "create temporary table trekk2010 (val char(16)) on commit drop;"
  TaxRate.connection.execute "copy trekk2010 from '/tmp/trekk2010.txt';"
  TaxRate.connection.execute <<EOS
insert into tax_rates (year, table_name, period_length, tax_type, gross_amount, tax_amount, created_at, updated_at)
 select 2010,
        substring(val from 1 for 4)::text,
        substring(val from 5 for 1)::integer,
        substring(val from 6 for 1)::integer,
        substring(val from 7 for 5)::integer,
        substring(val from 12 for 5)::integer,
        current_timestamp,
        current_timestamp
 from trekk2010;
EOS
  puts "done loading tax rates for 2010"
end


puts "..done loading seed data."

end # commit

