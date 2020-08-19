require 'rails_helper'

RSpec.describe Builders::Distribution::PullRequests do
  describe '.call' do
    let(:ruby_project) { create(:project, language: Language.find_by(name: 'ruby')) }
    let(:node_project) { create(:project, language: Language.find_by(name: 'nodejs')) }

    let!(:first_ruby_pull_request) do
      create(:pull_request,
             project: ruby_project,
             opened_at: Time.zone.now - 6.hours)
    end

    let!(:node_pull_request) do
      create(:pull_request,
             project: node_project,
             opened_at: Time.zone.now - 14.hours)
    end

    let!(:second_ruby_pull_request) do
      create(:pull_request,
             project: ruby_project,
             opened_at: Time.zone.now - 26.hours)
    end

    context 'when distribution is not filtered by language' do
      subject do
        described_class.call(
          department_name: 'backend',
          from: 4,
          languages: []
        )
      end

      before do
        first_ruby_pull_request.update!(merged_at: Time.zone.now)
        node_pull_request.update!(merged_at: Time.zone.now)
        second_ruby_pull_request.update!(merged_at: Time.zone.now)
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

      before do
        first_ruby_pull_request.update!(merged_at: Time.zone.now)
        node_pull_request.update!(merged_at: Time.zone.now)
        second_ruby_pull_request.update!(merged_at: Time.zone.now)
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
  end
end
