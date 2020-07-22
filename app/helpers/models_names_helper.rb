module ModelsNamesHelper
  def all_projects_names
    Project.pluck(:name)
  end

  def all_users_names
    User.pluck(:login, :id).insert(0, ['- select option -', 0])
  end

  def all_departments_names
    Department.pluck(:name).sort
  end

  def all_languages_names(department)
    department.languages.pluck(:name)
  end
end
