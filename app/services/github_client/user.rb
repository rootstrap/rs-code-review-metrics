module GithubClient
  class User < GithubClient::Base
    def initialize(username)
      @username = username
    end

    def repositories
      response = connection.get("/users/#{@username}/repos") do |request|
        request.params['type'] = 'member'
      end
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
