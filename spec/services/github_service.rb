require 'rails_helper'

RSpec.describe GithubService do
  subject { described_class.call(payload: payload, event: event) }

  context 'events' do
    context 'pull request' do
      let(:payload) { (create :pull_request_payload).merge((create :repository_payload)) }
      let(:event) { 'pull_request' }

      it 'ss' do
        subject
        byebug
      end
    end

    context 'review' do
      let(:payload) { create :review_payload.merge((create :repository_payload)) }
      let(:event) { 'review' }

    end

    context 'review comment' do
      let(:payload) { create :review_comment_payload.merge((create :repository_payload)) }
      let(:event) { 'review_comment' }

    end
  end
end
