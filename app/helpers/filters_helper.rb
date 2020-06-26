module FiltersHelper
  def all_projects_names
    Project.pluck(:name)
  end

  def all_users_names
    User.pluck(:login, :id).insert(0, ['- select option -', 0])
  end

  def all_departments_names
    Department.pluck(:name).sort
  end

  def language_choices(department)
    ['all'] + department.language_names
  end

  def period_choices
    ['all',
     'last week', 'last 2 weeks', 'last 3 weeks',
     'last month', 'last 3 months', 'last 6 months',
     'last year']
  end
end
