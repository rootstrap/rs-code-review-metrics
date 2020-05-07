class WordpressService
  def blog_posts(since: nil, posts: [], next_page_token: nil)
    request_params = {
      status: BlogPost.statuses[:publish],
      after: since&.iso8601,
      page_handle: next_page_token
    }
    response = connection.get(
      'rest/v1.1/me/posts',
      request_params,
      Authorization: "Bearer #{access_token}"
    )
    response_body = JSON.parse(response.body).with_indifferent_access

    posts += response_body[:posts]

    new_next_page_token = response_body.dig(:meta, :next_page)

    if new_next_page_token
      blog_posts(since: since, posts: posts, next_page_token: new_next_page_token)
    else
      posts
    end
  end

  private

  def access_token
    @access_token ||= request_access_token
  end

  def request_access_token
    request_body = {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'password',
      username: username,
      password: password
    }
    response = connection.post('oauth2/token', request_body)
    response_body = JSON.parse(response.body)
    raise_invalid_token_error(response_body) if response.status == 400

    response_body['access_token']
  end

  def connection
    Faraday.new('https://public-api.wordpress.com/')
  end

  def raise_invalid_token_error(response_body)
    raise(Wordpress::InvalidTokenRequestError, response_body['error_description'])
  end

  def client_id
    ENV['WORDPRESS_CLIENT_ID']
  end

  def client_secret
    ENV['WORDPRESS_CLIENT_SECRET']
  end

  def username
    ENV['WORDPRESS_USERNAME']
  end

  def password
    ENV['WORDPRESS_PASSWORD']
  end
end
