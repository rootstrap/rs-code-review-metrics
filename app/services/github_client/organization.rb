module GithubClient
  class Organization < GithubClient::Base
    MAX_REPOSITORIES_PER_PAGE = 100

    def repositories
      get_all_paginated_items('orgs/rootstrap/repos', MAX_REPOSITORIES_PER_PAGE)
    end
  end
end
