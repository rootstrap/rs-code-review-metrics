require 'rails_helper'

RSpec.describe Builders::Distribution::PullRequests::TimeToMerge do
  describe '.call' do
    before { travel_to Time.zone.parse('2020-08-20') }

    let(:ruby_repository) { create(:repository, language: Language.find_by(name: 'ruby')) }
    let(:node_repository) { create(:repository, language: Language.find_by(name: 'nodejs')) }

    let!(:first_ruby_pull_request) do
      create(:pull_request, :merged,
             repository: ruby_repository,
             opened_at: 6.hours.ago)
    end

    let!(:node_pull_request) do
      create(:pull_request, :merged,
             repository: node_repository,
             opened_at: 14.hours.ago)
    end

    let!(:second_ruby_pull_request) do
      create(:pull_request, :merged,
             repository: ruby_repository,
             opened_at: 26.hours.ago)
    end

    context 'when distribution is not filtered by language' do
      subject do
        described_class.call(
          department_name: 'backend',
          from: 4,
          languages: []
        )
      end

      it 'returns data for 1-12 hours' do
        expect(subject).to have_key('1-12')
      end
      it 'returns data for 12-24 hours' do
        expect(subject).to have_key('12-24')
      end
      it 'returns data for 24-36 hours' do
        expect(subject).to have_key('24-36')
      end
    end

    context 'when distribution is filtered by language' do
      subject do
        described_class.call(
          department_name: 'backend',
          from: 4,
          languages: ['ruby']
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
      let!(:third_ruby_pull_request_html_url_nil) do
        create(:pull_request, :merged,
               repository: ruby_repository,
               html_url: nil,
               opened_at: 40.hours.ago)
      end

      subject do
        described_class.call(
          department_name: 'backend',
          from: 4,
          languages: []
        )
      end

      it 'does not add the pull request to the data' do
        expect(subject).not_to have_key('36-48')
      end
    end
  end
end
