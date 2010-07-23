# Ensure we're in test mode to avoid mail timeout errors
# when creating users.
raise "Set RAILS_ENV=test before loading blueprint" unless Rails.env == 'test'

# Number of users
USER_COUNT = 150
#15000
# Number of companies
COMPANY_COUNT = 100
#10000
# Average number of products for a company
PRODUCT_COUNT = 20
# 50
# Average number of units
UNIT_COUNT = 7
# 7
# Average number of projects
PROJECT_COUNT = 7
# 7 
YEARS=(2000..2010)
MAX_JOURNAL_COUNT=500

def print_time name, &block
  print "#{name}..."
  a = Time.now
  foo = yield block
  b = Time.now
  print " Used #{b-a} seconds.\n"
  return foo
end

# largish data set to test scaling or whatever
require 'machinist/active_record'
require 'sham'
require 'faker'

if not $BULK_APPEND
  require File.expand_path(File.dirname(__FILE__) + "/../db/seed") if Role.all.empty?
  raise "roles not seeded" if Role.all.empty?
end

suffix = Time.now.usec.to_s

Sham.login { Faker::Internet.user_name }
Sham.email { Faker::Internet.email }
Sham.company_name { Faker::Company.name + suffix }
Sham.street1(:unique => false) { Faker::Address.street_name }
Sham.street2(:unique => false) { Faker::Address.secondary_address }
Sham.postal_code(:unique => false) { Faker::Address.uk_postcode }
Sham.town(:unique => false) { Faker::Address.city }
Sham.country(:unique => false) { Faker::Address.uk_country }
Sham.bs(:unique => false) { Faker::Company.bs.capitalize }
Sham.catch_phrase(:unique => false) { Faker::Company.catch_phrase.capitalize }
Sham.product_name(:unique => false) { Faker::Lorem.words(3).join(" ").capitalize }
Sham.account_name(:unique => false) { Faker::Lorem.words(3).join(" ").capitalize }
Sham.role_name(:unique => true) { Faker::Lorem.words(3).join("_").downcase }


User.blueprint do
  email { Sham.email }
  password { "Secret123" }
  password_confirmation { password }
end

Admin.blueprint do
  email { Sham.email }
  password { "Secret123" }
  password_confirmation { password }
end

Address.blueprint do
  street1
  street2 if rand(10) > 5
  postal_code
  town
  country
end

Company.blueprint do
  name { Sham.company_name }
  address { Address.make }
  next_invoice_number { 0 }
end

Unit.blueprint do
  name { Sham.company_name + " (unit)" }
  address
end

Project.blueprint do
  name { Sham.bs + " (project)" }
  comments { Sham.catch_phrase }
  address
end

Product.blueprint do
  price { BigDecimal.new( sprintf("%.2f", 10000 * rand) ) }
  name { Sham.product_name }
end

Account.blueprint do
  name { Sham.account_name }
  lodo_name { name }
  number { rand(10000) }
  debit_text { "debit" }
  credit_text { "credit" }
  comments { (rand(10) > 6) ? Sham.bs : "" }
  has_ledger { false }
end

Period.blueprint do
  status { Period::STATUSE_NAMES["Open"] }
end

Journal.blueprint do
end

JournalOperation.blueprint do
end

Role.blueprint do
  name { Sham.role_name }
end

bob = nil
admin = nil
companies = []
users = nil
roles=nil

# **********  Now create some data ***************


ActiveRecord::Base.transaction do

  if not $BULK_APPEND
    print_time "Creating users" do
      
      USER_COUNT.times {|i| user = User.make }
      
      bob = User.make(:email => "bob@bobsdomain.com")
      
      admin = Admin.make(:email => "admin@adminsdomain.com")
    end 
  else
    bob = User.where(:email => "bob@bobsdomain.com").first
    admin = User.where(:email => "admin@adminsdomain.com").first
  end    

  print_time "Creating companies" do
    COMPANY_COUNT.times {|i| companies << Company.make }
  end

  users = User.all
  roles = Role.all
  
  print_time "Attaching users to companies" do
    # attach users to companies
    (COMPANY_COUNT * 5).times do
      c = companies.rand
      u = users.rand
      r = roles.rand
      c.assignments.create(:user => u, :role => r)
    end
    
    # make sure bob is assigned to a few companies
    companies.shuffle[0..[COMPANY_COUNT, 5].min].each do |c|
      c.assignments.create(:user => bob, :role => Role.find_by_name("accountant"))
    end
  end

  print_time "Creating units" do
    # create a bunch of units/projects and attach them to companies
    (companies.size * UNIT_COUNT).times do
      Unit.make(:company => companies.rand)
    end
  end
  print_time "Creating projects" do
    (companies.size * PROJECT_COUNT).times do
      Project.make(:company => companies.rand)
    end
  end

  print_time "Creating company accounts" do
    # create some accounts
    companies.each do |c|
      print '.'
      # Vat accounts from empatix @ lodo.no
      
      # **** Outgoing vat; sales ***
      a2700 = Account.make(:company => c, :name => "Utg mva kode 10", :number => 2700)
      va2700 = VatAccount.create!(:company => c, :overridable => true, :target_account => a2700)
      VatAccountPeriod.create!(:vat_account => va2700, :percentage => 0, :valid_from => "1990-01-01")
      
      
      a2701 = Account.make(:company => c, :name => "Utg mva kode 11", :number => 2701)
      va2701 = VatAccount.create!(:company => c, :overridable => false, :target_account => a2701)
      VatAccountPeriod.create!(:vat_account => va2701, :percentage => 24, :valid_from => "1990-01-01")
      VatAccountPeriod.create!(:vat_account => va2701, :percentage => 25, :valid_from => "2005-01-01")
      
      
      a2702 = Account.make(:company => c, :name => "Utg mva kode 12", :number => 2702)
      va2702 = VatAccount.create!(:company => c, :overridable => false, :target_account => a2702)
      VatAccountPeriod.create!(:vat_account => va2702, :percentage => 12, :valid_from => "1990-01-01")
      VatAccountPeriod.create!(:vat_account => va2702, :percentage => 11, :valid_from => "2005-01-01")
      VatAccountPeriod.create!(:vat_account => va2702, :percentage => 13, :valid_from => "2006-01-01")
      VatAccountPeriod.create!(:vat_account => va2702, :percentage => 14, :valid_from => "2007-01-01")
      
      
      a2703 = Account.make(:company => c, :name => "Utg mva kode 13", :number => 2703)
      va2703 = VatAccount.create!(:company => c, :overridable => false, :target_account => a2703)
      VatAccountPeriod.create!(:vat_account => va2703, :percentage => 6, :valid_from => "1990-01-01")
      VatAccountPeriod.create!(:vat_account => va2703, :percentage => 7, :valid_from => "2005-01-01")
      VatAccountPeriod.create!(:vat_account => va2703, :percentage => 8, :valid_from => "2006-01-01")
      
      # *** Incoming vat; expenses ***
      a2710 = Account.make(:company => c, :name => "Ing mva kode 40", :number => 2710)
      va2710 = VatAccount.create!(:company => c, :overridable => true, :target_account => a2710)
      VatAccountPeriod.create!(:vat_account => va2710, :percentage => 0, :valid_from => "1990-01-01")
      
      
      a2711 = Account.make(:company => c, :name => "Ing mva kode 41", :number => 2711)
      va2711 = VatAccount.create!(:company => c, :overridable => false, :target_account => a2711)
      VatAccountPeriod.create!(:vat_account => va2711, :percentage => 24, :valid_from => "1990-01-01")
      VatAccountPeriod.create!(:vat_account => va2711, :percentage => 25, :valid_from => "2005-01-01")
      
      
      a2712 = Account.make(:company => c, :name => "Ing mva kode 42", :number => 2712)
      va2712 = VatAccount.create!(:company => c, :overridable => false, :target_account => a2712)
      VatAccountPeriod.create!(:vat_account => va2712, :percentage => 12, :valid_from => "1990-01-01")
      VatAccountPeriod.create!(:vat_account => va2712, :percentage => 11, :valid_from => "2005-01-01")
      VatAccountPeriod.create!(:vat_account => va2712, :percentage => 13, :valid_from => "2006-01-01")
      VatAccountPeriod.create!(:vat_account => va2712, :percentage => 14, :valid_from => "2007-01-01")
      
      
      a2713 = Account.make(:company => c, :name => "Ing mva kode 43", :number => 2713)
      va2713 = VatAccount.create!(:company => c, :overridable => false, :target_account => a2713)
      VatAccountPeriod.create!(:vat_account => va2713, :percentage => 6, :valid_from => "1990-01-01")
      VatAccountPeriod.create!(:vat_account => va2713, :percentage => 7, :valid_from => "2005-01-01")
      VatAccountPeriod.create!(:vat_account => va2713, :percentage => 8, :valid_from => "2006-01-01")
      
      
      # Other accounts
      Account.make(:company => c, :name => "Sales", :number => 3000, :vat_account => va2701)
      Account.make(:company => c, :name => "Cash", :number => 1900)
      Account.make(:company => c, :name => "Bank", :number => 1920)
      Account.make(:company => c, :name => "Materials", :number => 4000, :vat_account => va2711)
      Account.make(:company => c, :name => "Salaries", :number => 5000)
      Account.make(:company => c, :name => "Arbeidsgiveravgift", :number => 5400)
      Account.make(:company => c, :name => "NAV-refusjon, sykepenger", :number => 5800)
      Account.make(:company => c, :name => "Office supplies", :number => 6800, :vat_account => va2711)
      Account.make(:company => c, :name => "Phone expenses", :number => 6900, :vat_account => va2711)
      
      Account.make(:company => c, :name => "Accounts receivable", :number => 1500)
      # TODO: create some customers

      Account.make(:company => c, :name => "Accounts payable", :number => 2400)
    # TODO: create some suppliers
      
      Account.make(:company => c, :name => "Employees", :number => 2930)
      # TODO: create some employees
      
      # create some random filler accounts
      (rand(200) + 40).times do
        begin
          Account.make(:company => c)
        rescue
        end
      end
    end
  end

  print_time "Creating products" do
    (companies.size * PRODUCT_COUNT).times do |i|
      Product.make(:account => companies.rand.accounts.rand)
    end
  end
    
  # create random journal entries for the given period
  def create_journal_entries(company, period)
    #    puts "creating journal entries for #{company.name}, period: #{period.year}-#{period.nr}"
    # create journal entries
    date = Date.civil(period.year, period.nr, 1)
    sql = "insert into journals (company_id, period_id, journal_date) select #{company.id}, #{period.id}, ('#{date}'::date + interval '28 days' * random())::date from generate_series (1, #{rand(MAX_JOURNAL_COUNT)})"
    ActiveRecord::Base.connection.execute sql
    
  end
  
  def create_journal_operations(company)
    # create 4 journal_operations for every empty journal entry
    #    sql = "insert into journal_operations (journal_id, account_id, amount) select id as journal_id, #{sample_array_sql(company.accounts)}, (random() * 200 - 100)::numeric(16,2) as amount from (select j.id from journals j where j.company_id = #{company.id} and not exists (select 1 from journal_operations jo where jo.journal_id = j.id)) as aa, (select 1 from generate_series(1, (1 + random() * 5)::integer)) as bb"
    sql = "
insert into journal_operations 
(journal_id, account_id, amount) 
select 
    id as journal_id, 
    (select id from accounts where company_id=#{company.id} order by random() limit 1) as account_id,
    (random() * 200 - 100)::numeric(16,2) as amount 
from (select j.id from journals j 
where j.company_id = #{company.id} 
    and not exists (
        select 1 from journal_operations jo 
        where jo.journal_id = j.id)) as aa, (select 1 from generate_series(1, 4)) as bb"
    ActiveRecord::Base.connection.execute sql
    
    # find and close open journal entries
    sql = "
insert into journal_operations 
(journal_id, account_id, amount) 
select 
    journal_id, 
    (select id from accounts where company_id=#{company.id} order by random() limit 1) as account_id,
    -amount from (
        select journal_id, sum(amount) as amount 
        from journals j 
        inner join journal_operations jo 
            on (j.id = jo.journal_id) 
        where company_id = #{company.id} group by journal_id having sum(amount) <> 0) as qq"
    ActiveRecord::Base.connection.execute sql
  end

  def create_period(company, year, nr)
    p = Period.make(:company => company, :year => year, :nr => nr)
    create_journal_entries(company, p)
    # TODO: close period as appropriate
    #puts "p.journal count: #{p.journals.count} -- operations: #{p.journal_operations.count}"
  end

end

# create periods and fill these with tx data
companies.each_with_index do |c,idx|
  if idx%40 == 0
    print_time "Vacuuming the house" do
      ActiveRecord::Base.connection.execute "vacuum analyze"    
    end
  end
  print_time "Creating periods for company #{idx+1} of #{COMPANY_COUNT}" do
    ActiveRecord::Base.transaction do
      YEARS.each do |year|
        (1..12).each do |month|
          create_period(c, year, month)
        end
      end
      create_journal_operations(c)
    end
  end # ActiveRecord::Base.transaction do
end


