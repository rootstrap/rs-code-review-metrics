module GithubClient
  class Base
    private

    def connection
      Faraday.new('https://api.github.com') do |conn|
        conn.request(:authorization, :basic, ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
        conn.headers['Accept'] = 'application/vnd.github.v3+json'
        conn.response :raise_error
      end
    end

    def get_all_paginated_items(url, max_per_page, accumulated_items: [], page_number: 1)
      request_params = {
        page: page_number,
        per_page: max_per_page
      }

      response = connection.get(url) do |request|
        request.params = request_params
      end
      new_items = JSON.parse(response.body).map(&:with_indifferent_access)

      return accumulated_items if new_items.empty?

      get_all_paginated_items(
        url,
        max_per_page,
        accumulated_items: accumulated_items + new_items,
        page_number: page_number + 1
      )
    end

    def get_all_members(url, max_per_page, accumulated_users: [], page_number: 1)
      request_params = {
        page: page_number,
        per_page: max_per_page
      }

      response = connection.get(url) do |request|
        request.params = request_params
      end

      new_users = JSON.parse(response.body).map { |user| user['login'] }

      return accumulated_users if new_users.empty?

      get_all_members(
        url,
        max_per_page,
        accumulated_users: accumulated_users + new_users,
        page_number: page_number + 1
      )
    end
  end
end
