require 'rails_helper'

RSpec.describe WordpressService do
  describe '#access_token' do
    let(:client_id) { '11111' }
    let(:client_secret) { 'qwerty' }
    let(:username) { 'rootstrap@rootstrap.com' }
    let(:password) { 'rootstrap' }
    let(:request_params) do
      {
        client_id: ENV['WORDPRESS_CLIENT_ID'],
        client_secret: ENV['WORDPRESS_CLIENT_SECRET'],
        grant_type: 'password',
        username: ENV['WORDPRESS_USERNAME'],
        password: ENV['WORDPRESS_PASSWORD']
      }
    end

    subject { described_class.new.send(:access_token) }

    before do
      stub_env('WORDPRESS_CLIENT_ID', client_id)
      stub_env('WORDPRESS_CLIENT_SECRET', client_secret)
      stub_env('WORDPRESS_USERNAME', username)
      stub_env('WORDPRESS_PASSWORD', password)

      stub_request(:post, 'https://public-api.wordpress.com/oauth2/token')
        .with(body: request_params)
        .to_return(body: token_response, status: response_status)
    end

    context 'when the request is successful' do
      let(:access_token) { 'asdf' }
      let(:token_response) { JSON.generate(access_token: access_token) }
      let(:response_status) { 200 }

      it 'returns the access token' do
        expect(subject).to eq access_token
      end
    end

    context 'when the API fails to return an access token' do
      let(:password) { 'invalid_password' }
      let(:error_body) do
        {
          'error': 'invalid_request',
          'error_description': 'Incorrect username or password.'
        }
      end
      let(:token_response) { JSON.generate(error_body) }
      let(:response_status) { 400 }

      it 'raises an exception' do
        expect { subject }.to raise_error Wordpress::InvalidTokenRequestError
      end
    end
  end

  describe '#blog_posts' do
    let(:access_token) { 'asdf' }
    let(:authorization_header) { { 'Authorization': "Bearer #{access_token}" } }
    let(:blog_post) { create(:blog_post_payload) }
    let(:blog_posts_response) do
      JSON.generate(
        'posts': [blog_post],
        'found': 1
      )
    end
    let(:request_params) do
      {
        status: BlogPost.statuses[:publish],
        after: nil
      }
    end

    before do
      subject.instance_variable_set(:@access_token, access_token)
      stub_request(:get, 'https://public-api.wordpress.com/rest/v1.1/me/posts')
        .with(query: request_params.merge(page_handle: nil), headers: authorization_header)
        .to_return(body: blog_posts_response, status: 200)
    end

    it 'returns the published blog posts of the site' do
      expect(subject.blog_posts).to contain_exactly(blog_post.deep_symbolize_keys)
    end

    context 'when there is more than 1 page of results' do
      let(:next_page_token) { 'value=1564437351&blog=166779230&post=715' }
      let(:blog_post_2) { create(:blog_post_payload) }
      let(:blog_posts_response) do
        JSON.generate(
          'posts': [blog_post],
          'found': 2,
          'meta': {
            'next_page': next_page_token
          }
        )
      end
      let(:blog_posts_response_2) do
        JSON.generate(
          'posts': [blog_post_2],
          'found': 1
        )
      end

      before do
        stub_request(:get, 'https://public-api.wordpress.com/rest/v1.1/me/posts')
          .with(
            query: request_params.merge(page_handle: next_page_token),
            headers: authorization_header
          )
          .to_return(body: blog_posts_response_2, status: 200)
      end

      it 'returns all the published blog posts of the site' do
        expect(subject.blog_posts)
          .to match_array([blog_post, blog_post_2].map(&:deep_symbolize_keys))
      end
    end

    context 'when given a starting date' do
      let(:starting_date) { 30.days.ago }
      let(:blog_post_date) { Faker::Time.between(from: starting_date, to: Time.zone.today) }
      let(:blog_post) { create(:blog_post_payload, date: blog_post_date.iso8601) }
      let(:request_params) do
        {
          status: BlogPost.statuses[:publish],
          after: starting_date.iso8601
        }
      end

      it 'returns the published blog posts created since the given date' do
        expect(subject.blog_posts(since: starting_date))
          .to contain_exactly(blog_post.deep_symbolize_keys)
      end
    end
  end

  describe '#blog_post_views' do
    let(:access_token) { 'asdf' }
    let(:authorization_header) { { 'Authorization': "Bearer #{access_token}" } }
    let(:blog_site_id) { 11_111 }
    let(:url) do
      "https://public-api.wordpress.com/rest/v1.1/sites/#{blog_site_id}/stats/post/#{blog_post_id}"
    end
    let(:blog_post) { create(:blog_post) }
    let(:blog_post_id) { blog_post.blog_id }
    let(:blog_post_views_payload) do
      create(:blog_post_views_payload, publish_date: blog_post.published_at)
    end
    let(:blog_post_views_response) { JSON.generate(blog_post_views_payload) }

    before do
      stub_env('WORDPRESS_SITE_ID', blog_site_id)
      subject.instance_variable_set(:@access_token, access_token)
      stub_request(:get, url)
        .with(headers: authorization_header)
        .to_return(body: blog_post_views_response, status: 200)
    end

    it 'returns the views hash for the requested post' do
      expect(subject.blog_post_views(blog_post_id)).to eq blog_post_views_payload
    end
  end
end
