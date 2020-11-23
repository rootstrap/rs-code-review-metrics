module GithubClient
  class Organization < GithubClient::Base
    MAX_REPOSITORIES_PER_PAGE = 100
    MAX_USERS_PER_PAGE = 30

    def repositories
      get_all_paginated_items('orgs/rootstrap/repos', MAX_REPOSITORIES_PER_PAGE)
    end

    def members
      get_all_members('/orgs/rootstrap/members', MAX_USERS_PER_PAGE)
    end
  end
end
