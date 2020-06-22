module DepartmentsNamesHelper
  def all_departments_names
    Department.pluck(:name).sort
  end
end
