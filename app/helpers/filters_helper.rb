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

  def any_choice
    'all'
  end

  def language_choices(department)
    [any_choice] + department.language_names
  end

  def period_choices
    [any_choice,
     'last week', 'last 2 weeks', 'last 3 weeks',
     'last month', 'last 3 months', 'last 6 months',
     'last year']
  end

  def department_filter?
    params[:department_name].present?
  end

  def department_name_filter
    params[:department_name]
  end

  def chosen_period
    params[:period] || any_choice
  end

  def chosen_language
    params[:lang] || any_choice
  end

  def filter_url_query
    {
      project_name: params[:project_name],
      department_name: params[:department_name],
      metric: { period: params&.dig(:metric, :period) }
    }
  end
end
