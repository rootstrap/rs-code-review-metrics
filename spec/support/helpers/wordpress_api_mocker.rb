module WordpressApiMocker
  def stub_successful_blog_post_views_response(
    blog_post_id,
    blog_post_views_payload = create(:blog_post_views_payload)
  )
    stub_blog_post_views_response(blog_post_id, blog_post_views_payload, 200)
  end

  def stub_failed_blog_post_views_response(blog_post_id)
    stub_blog_post_views_response(blog_post_id, {}, 404)
  end

  def stub_blog_post_views_response(blog_post_id, response_body, status_code)
    stub_access_token_response
    stub_env('WORDPRESS_SITE_ID', blog_site_id)

    url = 'https://public-api.wordpress.com/rest/v1.1/sites/' \
          "#{blog_site_id}/stats/post/#{blog_post_id}"
    stub_request(:get, url)
      .with(headers: authorization_header)
      .to_return(body: JSON.generate(response_body), status: status_code)
  end

  def stub_failed_blog_posts_response(request_params: {})
    stub_access_token_response

    request_params = {
      status: BlogPost.statuses[:publish],
      after: default_starting_time.iso8601
    }.merge(request_params)

    stub_request(:get, 'https://public-api.wordpress.com/rest/v1.1/me/posts')
      .with(query: request_params.merge(page_handle: nil), headers: authorization_header)
      .to_return(status: 404)
  end

  def stub_blog_posts_response(
    request_params: {},
    blog_post_payloads: [create(:blog_post_payload)],
    page_size: 20
  )
    stub_access_token_response

    request_params = {
      status: BlogPost.statuses[:publish],
      after: default_starting_time.iso8601
    }.merge(request_params)

    found_blog_posts = blog_post_payloads.count
    groups_of_payloads = blog_post_payloads.in_groups_of(page_size, false)

    groups_of_payloads.each.with_index do |blog_posts_payload, index|
      stub_single_blog_post_response(
        blog_posts: blog_posts_payload,
        request_params: request_params,
        page_token: request_token_for(index, groups_of_payloads),
        next_page_token: response_token_for(index, groups_of_payloads),
        found_blog_posts: found_blog_posts
      )
      found_blog_posts -= blog_posts_payload.count
    end
  end

  def stub_single_blog_post_response(
    blog_posts:,
    request_params:,
    page_token:,
    next_page_token:,
    found_blog_posts:
  )
    blog_posts_response = {
      'posts': blog_posts,
      'found': found_blog_posts
    }

    blog_posts_response.merge!('meta': { 'next_page': next_page_token }) if next_page_token.present?

    stub_request(:get, 'https://public-api.wordpress.com/rest/v1.1/me/posts')
      .with(query: request_params.merge(page_handle: page_token), headers: authorization_header)
      .to_return(body: JSON.generate(blog_posts_response), status: 200)
  end

  def stub_successful_blog_post_response(blog_post_payload = create(:blog_post_payload))
    stub_blog_post_response(blog_post_payload['ID'], blog_post_payload, 200)
  end

  def stub_failed_blog_post_response(blog_post_id)
    stub_blog_post_response(blog_post_id, {}, 404)
  end

  def stub_blog_post_response(blog_post_id, response_body, status_code)
    stub_access_token_response
    stub_env('WORDPRESS_SITE_ID', blog_site_id)

    url = 'https://public-api.wordpress.com/rest/v1.1/sites/' \
          "#{blog_site_id}/posts/#{blog_post_id}"
    stub_request(:get, url)
      .with(headers: authorization_header)
      .to_return(body: JSON.generate(response_body), status: status_code)
  end

  def stub_access_token_response(
    response_body: { access_token: access_token },
    response_status: 200
  )
    stub_env_vars_for_access_token_request

    request_params = {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'password',
      username: username,
      password: password
    }

    stub_request(:post, 'https://public-api.wordpress.com/oauth2/token')
      .with(body: request_params)
      .to_return(body: JSON.generate(response_body), status: response_status)
  end

  def stub_env_vars_for_access_token_request
    stub_env('WORDPRESS_CLIENT_ID', client_id)
    stub_env('WORDPRESS_CLIENT_SECRET', client_secret)
    stub_env('WORDPRESS_USERNAME', username)
    stub_env('WORDPRESS_PASSWORD', password)
  end

  def authorization_header
    { 'Authorization': "Bearer #{access_token}" }
  end

  def request_token_for(payload_index, group_of_payloads)
    return if payload_index == 0

    generate_next_page_token(group_of_payloads[payload_index - 1])
  end

  def response_token_for(payload_index, group_of_payloads)
    return if group_of_payloads[payload_index + 1].blank?

    generate_next_page_token(group_of_payloads[payload_index])
  end

  def generate_next_page_token(blog_posts_payload)
    last_blog_post = blog_posts_payload.last
    "value=11111&blog=#{last_blog_post['site_ID']}&post=#{last_blog_post['ID']}"
  end

  def access_token
    'asdf'
  end

  def blog_site_id
    11_111
  end

  def client_id
    '11111'
  end

  def client_secret
    'qwerty'
  end

  def username
    'rootstrap@rootstrap.com'
  end

  def password
    'rootstrap'
  end

  def default_starting_time
    Time.zone.at(0)
  end
end
