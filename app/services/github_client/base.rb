module GithubClient
  class Base
    private

    def connection
      Faraday.new('https://api.github.com') do |conn|
        conn.basic_auth(ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
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
  end
end
