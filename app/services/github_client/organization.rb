module GithubClient
  class Organization < GithubClient::Base
    MAX_REPOSITORIES_PER_PAGE = 100

    def repositories(acc_repositories = [], page_number = 1)
      request_params = {
        page: page_number,
        per_page: MAX_REPOSITORIES_PER_PAGE
      }

      response = connection.get('orgs/rootstrap/repos') do |request|
        request.params = request_params
      end
      new_repositories = JSON.parse(response.body).map(&:with_indifferent_access)

      return acc_repositories if new_repositories.empty?

      repositories(acc_repositories + new_repositories, page_number + 1)
    end
  end
end
