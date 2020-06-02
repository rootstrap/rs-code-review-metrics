module ProjectsNamesHelper
  def all_projects_names
    Project.pluck(:name)
  end
end
