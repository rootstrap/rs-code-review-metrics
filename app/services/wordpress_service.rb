class WordpressService
  def blog_posts(posts: [], next_page_token: nil)
    response = connection.get(
      'rest/v1.1/me/posts',
      { status: BlogPost.statuses[:publish], page_handle: next_page_token },
      Authorization: "Bearer #{access_token}"
    )
    response_body = JSON.parse(response.body).with_indifferent_access

    posts += response_body[:posts]

    if response_body[:meta]
      blog_posts(posts: posts, next_page_token: response_body[:meta][:next_page])
    else
      posts
    end
  end

  private

  def access_token
    @access_token ||= get_access_token
  end

  def get_access_token
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