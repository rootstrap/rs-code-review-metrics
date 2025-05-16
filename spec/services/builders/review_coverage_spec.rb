require 'rails_helper'

RSpec.describe Builders::ReviewCoverage do
  describe '.call' do
    let(:pull_request) { create(:pull_request) }
    let(:total_files) { 10 }
    let(:files_with_comments) { 5 }
    let(:github_client) { instance_double(GithubClient::PullRequest) }

    before do
      allow(GithubClient::PullRequest).to receive(:new).with(pull_request).and_return(github_client)
      allow(github_client).to receive(:files).and_return(Array.new(total_files))
      allow(github_client).to receive(:comments).and_return(
        Array.new(files_with_comments) { { path: "file#{_1}.rb" } }
      )
    end

    subject { described_class.call(pull_request) }

    it 'creates a new review coverage' do
      expect { subject }.to change(ReviewCoverage, :count).by(1)
    end

    it 'creates it with the correct attributes' do
      review_coverage = subject
      expect(review_coverage.pull_request).to eq(pull_request)
      expect(review_coverage.total_files_changed).to eq(total_files)
      expect(review_coverage.files_with_comments_count).to eq(files_with_comments)
      expect(review_coverage.coverage_percentage).to eq(0.5)
    end

    context 'when the pull request has no comments' do
      let(:files_with_comments) { 0 }

      it 'creates a review coverage with zero coverage' do
        review_coverage = subject
        expect(review_coverage.files_with_comments_count).to eq(0)
        expect(review_coverage.coverage_percentage).to eq(0)
      end
    end
  end
end 