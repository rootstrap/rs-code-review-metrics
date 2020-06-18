module DepartmentsNamesHelper
  def all_departments_names
    Department.pluck(:name)
  end
end
