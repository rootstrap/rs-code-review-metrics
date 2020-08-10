module GithubClient
  class Base
    def connection
      Faraday.new('https://api.github.com') do |conn|
        conn.basic_auth(ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
        conn.response :raise_error
      end
    end
  end
end
