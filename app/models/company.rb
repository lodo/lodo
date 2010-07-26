# -*- coding: utf-8 -*-
class Company < ActiveRecord::Base
  has_many :accounts, :order => :number
  has_many :orders
  has_many :bills
  has_many :vat_accounts
  belongs_to :address

  has_many :assignments, :include => [:role, :user]
  accepts_nested_attributes_for :assignments, :allow_destroy => true,
    :reject_if => proc { |attrs| attrs["user_id"].blank? || attrs["role_id"].blank?}

  has_many :users, :through => :assignments, :order => "users.email"
  has_many :projects, :order => "lower(name)"
  has_many :units, :order => "lower(name)"
  has_many :periods
  has_many :journals

  # company acting as a template on create
  attr_accessor :template_company_id
  after_create :init_from_template, :if => proc { !self.template_company_id.blank? }

  # hmm.. no idea what validations make sense atm
  #validates :organization_number, :format => {:with => /^(NO|no)?[\d]{9,}(MVA|mva)?$/}

  def last_period
    return (self.periods.sort { |a,b| a.year != b.year ? a.year <=> b.year : a.nr <=> b.nr })[-1]
  end

  # Cloning accounts, vat_accounts, salary template etc.
  # from the company in self.template_company_id
  #
  # TODO: Fixme: What to do with periods (activatable_id)
  # and ledgers?
  def init_from_template
    raise "no template set" if self.template_company_id.blank?
    template = Company.where(:id => self.template_company_id).first

    # copy accounts
    accounts = {}
    template.accounts.each do |acc|
      attrs = acc.attributes
      attrs.delete(:vat_account_id)
      attrs.delete(:activatable_id)
      attrs.delete(:created_at)
      attrs.delete(:updated_at)
      attrs.update(:company_id => self.id)
      accounts[acc.id] = Account.create!(attrs)
    end

    # copy vat_accounts
    vat_accounts = {}
    template.vat_accounts.each do |acc|
      attrs = acc.attributes
      attrs.delete(:created_at)
      attrs.delete(:updated_at)
      attrs.update(:company_id => self.id)
      attrs.update(:target_account_id => accounts[acc.target_account_id].id)
      vat_accounts[acc.id] = VatAccount.create!(attrs)

      # copy vat_account_periods
      acc.vat_account_periods.each do |vap|
        copy_id = vat_accounts[acc.id].id
        VatAccountPeriod.create!(vap.attributes.merge(:vat_account_id => copy_id))
      end
    end

    # update accounts with vat_account id's
    template.accounts.where("vat_account_id is not null").each do |acc|
      accounts[acc.id].update_attributes!(:vat_account_id => vat_accounts[acc.vat_account_id].id)
    end
    
    # copy units. shallow, copying addresses doesn't make sense..
    template.units.each do |unit|
      u = Unit.new(unit.attributes)
      u.company = self
      u.address = Address.create!
      u.save!
    end
    
    # copy projects. not copying addresses.
    template.projects.each do |project|
      p = Project.new(project.attributes)
      p.company = self
      p.address = Address.create!
      p.save!
    end

  end

  def employees
    # FIXME: Don't hardcode this here. Make intelligent configuration
    # possible. Talk to Arnt about how he wants the UI to actually
    # look, first.
    self.accounts.where(:number => "2930").first.ledgers
  end

  def paychecks
    r = Paycheck.where(:employee_id => employees).joins([:employee, :period]).order("periods.year desc, periods.nr desc, lower(ledgers.name)")
    r
  end

end
