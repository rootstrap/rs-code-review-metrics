require 'rails_helper'

RSpec.describe Builders::Distribution::PullRequests::ReviewCoverageRepository do
  describe '.call' do
    let(:from) { 4.weeks.ago }
    let(:to) { Time.zone.now }
    let(:repository_one) { create(:repository) }
    let(:repository_two) { create(:repository) }

    let!(:first_pull_request) do
      create(:pull_request, :merged,
             repository: repository_one,
             html_url: 'test_pr_url_one',
             merged_at: 6.hours.ago)
    end

    let!(:second_pull_request) do
      create(:pull_request, :merged,
             repository: repository_two,
             html_url: 'test_pr_url_two',
             merged_at: 14.hours.ago)
    end

    let!(:third_pull_request) do
      create(:pull_request, :merged,
             repository: repository_one,
             html_url: 'test_pr_url_three',
             merged_at: 26.hours.ago)
    end

    before do
      first_pull_request.review_coverage.update!(coverage_percentage: 0.25)
      second_pull_request.review_coverage.update!(coverage_percentage: 0.75)
      third_pull_request.review_coverage.update!(coverage_percentage: 0.50)
    end

    context 'with correct params' do
      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: from,
          to: to
        )
      end

      it 'returns data for 0-25% coverage' do
        expect(subject).to have_key('20-40')
        expect(subject['20-40'].first[:value]).to eq(25.0)
      end

      it 'returns data for 50-75% coverage' do
        expect(subject).to have_key('40-60')
        expect(subject['40-60'].first[:value]).to eq(50.0)
      end

      it 'does not return data for 25-50% coverage' do
        expect(subject).not_to have_key('10-20')
      end
    end

    context 'when pull request has html_url attribute nil' do
      let!(:pull_request_html_url_nil) do
        create(:pull_request, :merged,
               repository: repository_one,
               html_url: nil,
               merged_at: 40.hours.ago)
      end

      before do
        pull_request_html_url_nil.review_coverage.update!(coverage_percentage: 0.90)
      end

      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: from,
          to: to
        )
      end

      it 'does not add the pull request to the data' do
        expect(subject).not_to have_key('60-80')
      end
    end

    context 'when pull request belongs to ignored user' do
      let(:ignored_user) { create(:user, login: 'ignored_user') }
      let!(:setting) { create(:setting, key: 'ignored_users', value: ignored_user.login) }

      let!(:ignored_pull_request) do
        create(:pull_request, :merged,
               repository: repository_one,
               merged_at: 6.hours.ago,
               owner: ignored_user)
      end

      before do
        ignored_pull_request.review_coverage.update!(coverage_percentage: 0.25)
      end

      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: from,
          to: to
        )
      end

      it 'does not include pull requests from ignored users' do
        expect(subject['20-40'].pluck(:html_url)).not_to include(ignored_pull_request.html_url)
      end
    end
  end
end
