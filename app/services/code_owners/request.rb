module CodeOwners
  class Request < BaseService
    def call
      Project.find_each do |project|
        content_file = GithubRepositoryClient.new(project.name).code_owners
        next if content_file.nil?

        code_owners = CodeOwners::FileHandler.call(content_file)
        CodeOwners::ProjectHandler.call(project, code_owners)
      end
    end
  end
end
