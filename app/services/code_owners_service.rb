class CodeOwnersService < BaseService
  def call
    Project.all.find_each do |project|
      content_file = GithubReposApi.new(project.name).get_content_from_file('CODEOWNERS')
      next if content_file.empty?

      code_owners_names = build_code_owners_array(content_file)
      remove_old_code_owners(code_owners_names, project)
      add_new_code_owners(code_owners_names, project)
    end
  end

  def add_new_code_owners(code_owners_names, project)
    current_code_owners = project.code_owners
    code_owners_names.each do |code_owner_name|
      user = User.find_by(login: code_owner_name)
      current_code_owners << user unless current_code_owners.include?(user)
    end
  end

  def remove_old_code_owners(code_owners_names, project)
    project.code_owners.delete(User.where.not(login: code_owners_names))
  end

  def build_code_owners_array(content_file)
    content_file.lines.flat_map do |line|
      line.scan(%r{@(\w+)}).flatten
    end
  end
end
