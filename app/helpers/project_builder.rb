module ProjectBuilder
  def find_or_create_project(repository_data)
    Project.find_or_create_by!(github_id: repository_data['id']) do |project|
      project.name = repository_data['name']
      project.description = repository_data['description']
    end
  end
end
