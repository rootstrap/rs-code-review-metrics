module ModelsNamesHelper
  def all_users_names
    User.pluck(:login, :id).insert(0, ['Choose a user', 0])
  end

  def all_departments_names
    Department.pluck(:name).sort
  end

  def all_languages_names(department)
    department.languages.pluck(:name)
  end

  def all_products
    Product.all.includes(:repositories)
  end
end
