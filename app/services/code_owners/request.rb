module CodeOwners
  class Request < BaseService
    def call
      Repository.find_each do |repository|
        content_file = GithubClient::Repository.new(repository).code_owners
        next if content_file.empty?

        code_owners = CodeOwners::FileHandler.call(content_file)
        CodeOwners::RepositoryHandler.call(repository, code_owners)
      end
    end
  end
end
