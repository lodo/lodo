require 'test_helper'

class CompanyTest < ActiveSupport::TestCase


  test "using an existing company as a template" do
    # find a company initialized from blueprints.
    # this probably is -- it certainly should be! -- non-ideomatic use of AR
    template = Company.select("companies.id").joins(:accounts).group("companies.id").having("count (*) > 10").first.reload

    company = Company.new(:name => "Jalla Inc", :template_company_id => template.id)
    assert company.save

    assert_equal template.vat_accounts.size, company.vat_accounts.size
    assert_equal template.units.size, company.units.size
    assert_equal template.projects.size, company.projects.size

    # let's compare the accounts for good measure
    f = proc {|acc| [acc.number, acc.name, acc.lodo_name]}
    assert_equal Set.new(template.accounts.map(&f)), Set.new(company.accounts.map(&f))

    # find account with a vat account and compare vat accounts..
    a1 = template.accounts.where("vat_account_id is not null").first
    copy = company.accounts.where(:name => a1.name).first

    assert_not_nil copy.id
    assert_not_equal a1.id, copy.id
    assert_not_nil copy.vat_account_id
    assert_equal a1.vat_account.target_account.name, copy.vat_account.target_account.name

    # ensure the tax rates for this vat account were copied as well
    assert_equal Set.new(a1.vat_account.vat_account_periods.map {|p| [p.vat_account.target_account.name, p.valid_from, p.percentage]}), Set.new(copy.vat_account.vat_account_periods.map {|p| [p.vat_account.target_account.name, p.valid_from, p.percentage]})
  end

end
