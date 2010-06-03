module CompaniesHelper

  # list users assigned to the current company, along with their roles
  def list_users(company)
    users = {}
    company.assignments.each do |a|
      users[a.user] = users[a.user] || []
      users[a.user] << a.role
    end
    users.map {|u, rs| list_user(u, rs)}.join("<br />\n")
  end


  protected
  def list_user(user, roles)
    role_string = roles.map {|r| r.name.capitalize}.join(", ")
    "#{h user.email} (#{role_string})"
  end

end
