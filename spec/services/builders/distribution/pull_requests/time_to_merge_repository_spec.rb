require 'rails_helper'

RSpec.describe Builders::Distribution::PullRequests::TimeToMergeRepository do
  describe '.call' do
    before { travel_to Time.zone.parse('2020-08-20') }

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

    before do
      first_pull_request.update!(merged_at: Time.zone.now)
      second_pull_request.update!(merged_at: Time.zone.now)
      third_pull_request.update!(merged_at: Time.zone.now)
    end

    context 'with correct params' do
      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: 4
        )
      end

      it 'returns data for 1-12 hours' do
        expect(subject).to have_key('1-12')
      end

      it 'returns data for 24-36 hours' do
        expect(subject).to have_key('24-36')
      end

      it 'does not return any data for 12-24 hours' do
        expect(subject).not_to have_key('12-24')
      end
    end

    context 'when pull request has html_url attribute nil' do
      let!(:pull_request_html_url_nil) do
        create(:pull_request,
               repository: repository_one,
               html_url: nil,
               opened_at: 40.hours.ago,
               merged_at: Time.zone.now)
      end

      subject do
        described_class.call(
          repository_name: repository_one.name,
          from: 4
        )
      end

      it 'does not add the pull request to the data' do
        expect(subject).not_to have_key('36-48')
      end
    end
  end
end
