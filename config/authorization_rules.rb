
authorization do

  # no need for privs. admin authentication will do
  #role :admin do
  #  has_permission_on :admin_users, :to => :manage
  #  has_permission_on :admin_companies, :to => :manage
  #  has_permission_on :admin_admins, :to => :manage
  #end

  role :user do
    has_permission_on :accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :vat_accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :vat_accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :vat_accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}, "period.status" => is {1}
    end

  end

  role :accountant do
    has_permission_on :accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end

    has_permission_on :vat_accounts, :to => :manage do
      if_attribute :company_id => is {user.current_company.id}
    end



  end

  role :employee do
    has_permission_on :salaries, :to => :read do
      if_attribute :employee_id => is {user.id}
    end
  end
end

privileges do
  privilege :read do
    includes :index, :show
  end

  privilege :manage do
    includes :read, :create, :update, :delete, :new, :edit
  end
end
