module GithubClient
  class User < GithubClient::Base
    def initialize(username)
      @username = username
    end

    def repositories
      response = connection.get("/users/#{@username}/repos") do |request|
        request.params['type'] = 'member'
      end
      response_body = response.body
      response_body.empty? ? [] : JSON.parse(response_body, symbolize_names: true)
    end
  end
end
