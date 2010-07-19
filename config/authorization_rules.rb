
authorization do

  role :admin do
    has_permission_on :authorization_rules, :to => :manage
    has_permission_on :authorization_usages, :to => :manage
    # just being authenticated as an admin covers
    # authorization for the admin ui
  end

  role :user do
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :authorization_usages, :to => :read

    has_permission_on :accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :vat_accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :projects, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :units, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :products, :to => :manage do
      if_attribute :account => { :company_id => is {user.current_company.id} }
    end

    has_permission_on :journals, :to => :manage, :join_by => :and do
      if_attribute :company_id => is {user.current_company.id}
      if_attribute :period => { :status => [ Period::STATUSE_NAMES['Open'] ] }
    end
    has_permission_on :journals, :to => :read do
      if_attribute :company_id => is {user.current_company.id}
    end
    has_permission_on :journals, :to => :new

    has_permission_on :bills, :to => :manage, :join_by => :and do
      if_attribute :company_id => is {user.current_company.id}
      if_attribute :period => { :status => [ Period::STATUSE_NAMES['Open'] ] }
    end
    has_permission_on :bills, :to => :read do
      if_attribute :company_id => is {user.current_company.id}
    end
    has_permission_on :bills, :to => :new

    has_permission_on :orders, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :periods, :to => [:index, :new, :elevate_status, :move_bills] do
      if_attribute :company_id => is {user.current_company.id}
      if_attribute :company_id => nil
    end

  end

  role :accountant do

    includes :user

    has_permission_on :journals, :to => :manage, :join_by => :and do
      if_attribute :company_id => is {user.current_company.id}
      if_attribute :period => { :status => [ Period::STATUSE_NAMES['Open'], Period::STATUSE_NAMES['Done'] ] }
    end

    has_permission_on :bills, :to => :manage, :join_by => :and do
      if_attribute :company_id => is {user.current_company.id}
      if_attribute :period => { :status => [ Period::STATUSE_NAMES['Open'], Period::STATUSE_NAMES['Done'] ] }
    end
  end

  role :employee do
    has_permission_on :salaries, :to => :read do
      if_attribute :employee_id => is {user.id}
    end
  end
end

privileges do
  privilege :manage do
    includes :create, :update, :delete, :new, :edit, :index, :show, :read
  end
end
