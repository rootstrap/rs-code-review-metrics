module ModelsNamesHelper
  def all_projects_names
    Project.pluck(:name).insert(0, ['- select option -', 0])
  end

  def all_users_names
    User.pluck(:login, :id).insert(0, ['- select option -', 0])
  end
end
