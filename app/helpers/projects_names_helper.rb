module ProjectsNamesHelper
  def projects_names
    Project.pluck(:name)
  end
end
