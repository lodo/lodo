# Smallish data set for unit and selenium test purposes
require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.login { Faker::Internet.user_name }
Sham.email { Faker::Internet.email }
Sham.company_name { Faker::Company.name }
Sham.street1(:unique => false) { Faker::Address.street_name }
Sham.street2(:unique => false) { Faker::Address.secondary_address }
Sham.postal_code(:unique => false) { Faker::Address.uk_postcode }
Sham.town(:unique => false) { Faker::Address.city }
Sham.country(:unique => false) { Faker::Address.uk_country }
Sham.bs(:unique => false) { Faker::Company.bs.capitalize }
Sham.catch_phrase(:unique => false) { Faker::Company.catch_phrase.capitalize }
Sham.product_name(:unique => false) { Faker::Lorem.words(3).join(" ").capitalize }
Sham.account_name(:unique => false) { Faker::Lorem.words(3).join(" ").capitalize }


User.blueprint do
  login { Sham.login }
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

# using populator for this
#Product.blueprint do
#  price { BigDecimal.new( sprintf("%.2f", 10000 * rand) ) }
#  name { Sham.product_name }
#end

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


# **********  Now create some data ***************
ActiveRecord::Base.transaction do

  200.times {|i| user = User.make }

  bob = User.make(:login => "bob_the_user")
  admin = User.make(:login => "admin_user")

  100.times {|i| Company.make}

  users = User.all
  companies = Company.all

  # attach users to companies
  companies.each {|c| c.users << users.rand }
  (Company.count * 2).times do
    c = companies.rand
    u = users.rand
    c.users << u unless c.users.include?(u)
  end

  # make sure bob is assigned to a few companies
  companies.shuffle[0..4].each do |c|
    c.users << bob unless c.users.include?(bob)
  end

  # create a bunch of units/projects and attach them to companies
  (Company.count * 3).times do
    Unit.make(:company => companies.rand)
    Project.make(:company => companies.rand)
  end

  # create some accounts
  Company.all.each do |c|
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
    (rand(120) + 40).times do
      begin
        Account.make(:company => c)
      rescue
      end
    end
  end

  # let's go with an avg of 15 products / company
  Product.populate(Company.count * 15) do |product|
    product.account_id = companies.rand.accounts.rand.id
    product.price = BigDecimal.new( sprintf("%.2f", 10000 * rand) )
    product.name = Sham.product_name
  end

  # create random journal entries for the given period
  def create_journal_entries(company, period)
    date = Date.civil(period.year, period.nr, rand(28) + 1)
    puts "creating journal entries for #{company.name}, period: #{period.year}-#{period.nr}"
    Journal.populate(0..200) do |je|
      je.company_id = company.id
      je.period_id = period.id
      je.journal_date = date
      total = 0
      JournalOperation.populate(1..4) do |jo|
        jo.journal_id = je.id
        jo.account_id = company.accounts.rand.id
        jo.amount = -100..100
        total += jo.amount
      end
      # close transaction
      JournalOperation.populate(1) do |jo|
        jo.journal_id = je.id
        jo.account_id = company.accounts.rand.id
        jo.amount = -total
      end
    end
  end

  def create_period(company, year, nr)
    p = Period.make(:company => company, :year => year, :nr => nr)
    create_journal_entries(company, p)
    # TODO: close period as appropriate
    #puts "p.journal count: #{p.journals.count} -- operations: #{p.journal_operations.count}"
  end

  # create periods and fill these with tx data
  companies.each do |c|
    (2000..2010).each do |year|
      (1..12).each do |month|
        create_period(c, year, month)
      end
    end
  end

end # ActiveRecord::Base.transaction do

