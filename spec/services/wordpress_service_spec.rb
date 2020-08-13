require 'rails_helper'

RSpec.describe WordpressService do
  describe '#access_token' do
    subject { described_class.new.send(:access_token) }

    before do
      stub_access_token_response(response_body: token_response, response_status: response_status)
    end

    context 'when the request is successful' do
      let(:access_token) { 'asdf' }
      let(:token_response) { { access_token: access_token } }
      let(:response_status) { 200 }

      it 'returns the access token' do
        expect(subject).to eq access_token
      end
    end

    context 'when the API fails to return an access token' do
      let(:token_response) do
        {
          'error': 'invalid_request',
          'error_description': 'Incorrect username or password.'
        }
      end
      let(:response_status) { 400 }

      it 'raises an exception' do
        expect { subject }.to raise_error Wordpress::InvalidTokenRequestError
      end
    end
  end

  describe '#blog_posts' do
    context 'when the request succeeds' do
      let(:blog_post) { create(:blog_post_payload) }

      before do
        stub_blog_posts_response(blog_post_payloads: [blog_post])
      end

      it 'returns the published blog posts of the site' do
        expect(subject.blog_posts).to contain_exactly(blog_post.deep_symbolize_keys)
      end

      context 'when there is more than 1 page of results' do
        let(:blog_post_2) { create(:blog_post_payload) }

        before do
          stub_blog_posts_response(blog_post_payloads: [blog_post, blog_post_2], page_size: 1)
        end

        it 'returns all the published blog posts of the site' do
          expect(subject.blog_posts).to contain_exactly(blog_post, blog_post_2)
        end
      end

      context 'when given a starting date' do
        let(:starting_date) { 30.days.ago }
        let(:blog_post_date) { Faker::Time.between(from: starting_date, to: Time.zone.today) }
        let(:blog_post) { create(:blog_post_payload, date: blog_post_date.iso8601) }

        before do
          stub_blog_posts_response(
            request_params: { after: starting_date.iso8601 },
            blog_post_payloads: [blog_post]
          )
        end

        it 'returns the published blog posts created since the given date' do
          expect(subject.blog_posts(since: starting_date))
            .to contain_exactly(blog_post.deep_symbolize_keys)
        end
      end
    end

    context 'when the request fails' do
      before { stub_failed_blog_posts_response }

      it 'raises an exception' do
        expect { subject.blog_posts }.to raise_error Faraday::ClientError
      end
    end
  end

  describe '#blog_post_views' do
    let(:blog_post) { create(:blog_post) }
    let(:blog_post_id) { blog_post.blog_id }

    context 'when the request succeeds' do
      let(:blog_post_views_payload) do
        create(:blog_post_views_payload, publish_datetime: blog_post.published_at)
      end

      before do
        stub_successful_blog_post_views_response(blog_post_id, blog_post_views_payload)
      end

      it 'returns the views hash for the requested post' do
        expect(subject.blog_post_views(blog_post_id)).to eq blog_post_views_payload
      end
    end

    context 'when the request fails' do
      before { stub_failed_blog_post_views_response(blog_post_id) }

      it 'raises an exception' do
        expect { subject.blog_post_views(blog_post_id) }.to raise_error Faraday::ClientError
      end
    end
  end

  describe '#blog_post' do
    let(:blog_post_payload) { create(:blog_post_payload) }
    let(:blog_post_id) { blog_post_payload['ID'] }

    context 'when the request succeeds' do
      before { stub_successful_blog_post_response(blog_post_payload) }

      it 'returns the payload of the requested post' do
        expect(subject.blog_post(blog_post_id)).to eq blog_post_payload
      end
    end

    context 'when the request fails' do
      before { stub_failed_blog_post_response(blog_post_id) }

      it 'raises an exception' do
        expect { subject.blog_post(blog_post_id) }.to raise_error Faraday::ClientError
      end
    end
  end
end
