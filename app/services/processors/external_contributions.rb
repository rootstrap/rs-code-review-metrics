module Processors
  class ExternalContributions < Base
    def call
      usernames.each do |username|
        repositories_data = GithubClient::User.new(username).repositories
        repositories_data.each do |repository_data|
          next if usernames.include? repository_data[:owner][:login]

          project = Builders::ExternalProject.call(repository_data)
          pull_requests_data = GithubClient::Repository.new(project).pull_requests
          pull_requests_data
            .select { |pull_request_data| pull_request_data[:user][:login] == username }
            .each do |pull_request|
              pull_request = Builders::ExternalPullRequest.call(pull_request, project)
            end
        end
      end
    end

    def usernames
      @usernames = User.pluck(:login)
    end
  end
end
