require 'test_helper'

class CompanyTest < ActiveSupport::TestCase


  test "using an existing company as a template" do
    # find a company initialized from blueprints.
    # this probably is -- it certainly should be! -- non-ideomatic use of AR
    template = Company.select("companies.id").joins(:accounts).group("companies.id").having("count (*) > 10").first.reload

    100.times do |i|
      u = nil
      u = template.units.rand if rand(10) > 7
      p = nil
      p = template.projects.rand if rand(10) > 6
      e = nil
      e = template.employees.rand if rand(10) > 7
      PaycheckLineTemplate.make(:company => template, :unit => u, :project => p, :employee => e, :account => template.accounts.rand)
    end

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

    # ensure the tax rates for this vat account were copied
    f = proc {|p| [p.vat_account.target_account.name, p.valid_from, p.percentage]}
    assert_equal Set.new(a1.vat_account.vat_account_periods.map(&f)), Set.new(copy.vat_account.vat_account_periods.map(&f))

    # compare paycheck templates
    f = proc {|line| [line.line_type, line.description, line.count, line.amount, line.unit ? line.unit.name : "", line.project ? line.project.name : "", line.account ? line.account.name : ""]}
    assert_equal Set.new(company.paycheck_line_templates.map(&f)), Set.new(template.paycheck_line_templates.map(&f))
  end

end
