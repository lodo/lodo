
authorization do
  role :admin do
    has_permission_on :users, :to => :manage
    #has_permission_on :companies, :to => :manage
  end
  role :user do
    # edit periods where status = 1
  end
  role :accountant do
    # edit periods where status = 1 or 2
  end
  role :employee do
    has_permission_on :salaries, :to => :read do
      if_attribute :employee_id => is {user.id}
    end
  end
end

privileges do
  privilege :manage do
    includes :create, :read, :update, :delete, :index, :new
  end
end
