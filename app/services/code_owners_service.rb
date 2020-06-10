class CodeOwnersService < BaseService
  def call
    Project.all.find_each do |project|
      github_api = GithubReposApi.new(project.name)
      content = github_api.get_content_of_file('CODEOWNERS')
      next if content.empty?

      save_code_owners_from_file(project, content)
    end
  end


  def save_code_owners_from_file(project, content)
    content.split('*').second.split("@").each do |code_owner_name|
      user = User.find_by(login: code_owner_name.strip)
      next if user.nil?

      project.code_owners << user
    end
  end
end
