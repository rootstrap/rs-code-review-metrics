require 'rails_helper'

RSpec.describe Builders::Distribution::PullRequests::PullRequestSizeRepository do
  describe '.call' do
    before { travel_to Time.zone.parse('2020-08-20') }
    let(:from) { 4.weeks.ago }
    let(:to) { Time.zone.now }
    let(:repository_one) { create(:repository) }
    let(:repository_two) { create(:repository) }

    let!(:first_pull_request) do
      create(:pull_request,
             repository: repository_one,
             html_url: 'test_pr_url_one',
             opened_at: 6.hours.ago)
    end

    let!(:second_pull_request) do
      create(:pull_request,
             repository: repository_two,
             html_url: 'test_pr_url_two',
             opened_at: 14.hours.ago)
    end

    let!(:third_pull_request) do
      create(:pull_request,
             repository: repository_one,
             html_url: 'test_pr_url_three',
             opened_at: 26.hours.ago)
    end

    let!(:fourth_pull_request) do
      create(:pull_request,
            repository: repository_one,
            size: Faker::Number.within(range: 0..100),
            html_url: 'test_pr_url_four',
            opened_at: 26.hours.ago)
    end

    let!(:fifth_pull_request) do
      create(:pull_request,
            repository: repository_two,
            size: Faker::Number.within(range: 100..200),
            html_url: 'test_pr_url_five',
            opened_at: 15.hours.ago)
    end

    before do
      first_pull_request.update!(merged_at: Time.zone.now)
      second_pull_request.update!(merged_at: Time.zone.now)
      third_pull_request.update!(merged_at: Time.zone.now)
      fourth_pull_request.update!(merged_at: Time.zone.now)
      fifth_pull_request.update!(merged_at: Time.zone.now)
    end

    context 'with correct params' do
      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: from,
          to: to
        )
      end

      it 'returns data for pull request with 1000+ lines' do
        expect(subject).to have_key('1000+')
      end

      it 'returns data for pull request with 1-99 lines' do
        expect(subject).to have_key('1-99')
      end

      it 'does not return any data for pull request with 100-200 lines' do
        expect(subject).not_to have_key('100-199')
      end
    end

    context 'when pull request has html_url attribute nil' do
      let!(:pull_request_html_url_nil) do
        create(:pull_request,
               repository: repository_one,
               size: Faker::Number.within(range: 700..800),
               html_url: nil,
               opened_at: 40.hours.ago,
               merged_at: Time.zone.now)
      end

      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: from,
          to: to
        )
      end

      it 'does not add the pull request to the data' do
        expect(subject).not_to have_key('700-799')
      end
    end
  end
end
