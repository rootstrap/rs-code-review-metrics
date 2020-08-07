class WordpressService
  def blog_posts(since: Time.zone.at(0), posts: [], next_page_token: nil)
    request_params = {
      status: BlogPost.statuses[:publish],
      after: since&.iso8601,
      page_handle: next_page_token
    }
    response_body = get_response_body('me/posts', request_params)

    posts += response_body[:posts]

    new_next_page_token = response_body.dig(:meta, :next_page)

    if new_next_page_token
      blog_posts(since: since, posts: posts, next_page_token: new_next_page_token)
    else
      posts
    end
  end

  def blog_post_views(blog_post_id)
    get_response_body("sites/#{site_id}/stats/post/#{blog_post_id}")
  end

  def blog_post(blog_post_id)
    get_response_body("sites/#{site_id}/posts/#{blog_post_id}")
  end

  private

  def get_response_body(url, request_params = {})
    response = connection.get(url) do |request|
      request.params = request_params
    end
    JSON.parse(response.body).with_indifferent_access
  end

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
    response = Faraday.post('https://public-api.wordpress.com/oauth2/token', request_body)
    response_body = JSON.parse(response.body)
    raise_invalid_token_error(response_body) if response.status == 400

    response_body['access_token']
  end

  def connection
    Faraday.new('https://public-api.wordpress.com/rest/v1.1/') do |conn|
      conn.authorization(:Bearer, access_token)
    end
  end

  def raise_invalid_token_error(response_body)
    raise(Wordpress::InvalidTokenRequestError, response_body['error_description'])
  end

  def site_id
    ENV['WORDPRESS_SITE_ID']
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
