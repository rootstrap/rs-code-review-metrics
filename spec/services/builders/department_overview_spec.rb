require 'rails_helper'

RSpec.describe Builders::DepartmentOverview do
  describe '.call' do
    let(:internal) { Repository.relevances[:internal] }
    let(:commercial) { Repository.relevances[:commercial] }
    let(:ignored) { Repository.relevances[:ignored] }
    let(:unassigned) { Repository.relevances[:unassigned] }

    let(:ruby) { Language.find_or_create_by(name: 'ruby') }
    let(:python) { Language.find_or_create_by(name: 'python') }
    let!(:nodejs) { Language.find_or_create_by(name: 'nodejs') }

    let(:from) { 4.weeks.ago }
    let(:to) { Time.zone.now }

    let(:outdated_date) { from.yesterday }
    let(:in_effect_date) { from.tomorrow }

    let(:department) { ruby.department }

    before do
      # counted repositories
      create_repository(language: ruby, relevance: internal, last_activity_at: in_effect_date)
      create_repository(language: ruby, relevance: commercial, last_activity_at: in_effect_date)

      create_repository(language: python, relevance: internal, last_activity_at: in_effect_date)
      create_repository(language: python, relevance: internal, last_activity_at: in_effect_date)

      # not counted repositories
      create_repository(language: ruby, relevance: unassigned, last_activity_at: in_effect_date)
      create_repository(language: ruby, relevance: internal, last_activity_at: outdated_date)

      create_repository(language: python, relevance: ignored, last_activity_at: in_effect_date)
    end

    describe 'count by relevance' do
      it 'returns the amount of repositories by language and relevance' do
        overview = described_class.call(department, from: from, to: to)

        expect(overview[:ruby][:per_relevance][:internal]).to eq 1
        expect(overview[:ruby][:per_relevance][:commercial]).to eq 1
        expect(overview[:python][:per_relevance][:internal]).to eq 2
        expect(overview[:python][:per_relevance][:commercial]).to eq 0
        expect(overview[:nodejs][:per_relevance][:internal]).to eq 0
        expect(overview[:nodejs][:per_relevance][:commercial]).to eq 0
      end

      it 'does not count any ignored or unassigned repository' do
        overview = described_class.call(department, from: from, to: to)

        expect(overview[:ruby][:per_relevance][:unassigned]).not_to be_present
        expect(overview[:python][:per_relevance][:ignored]).not_to be_present
      end
    end

    describe 'total count' do
      it 'returns the totals for each language' do
        overview = described_class.call(department, from: from, to: to)

        expect(overview[:ruby][:totals]).to eq 2
        expect(overview[:python][:totals]).to eq 2
        expect(overview[:nodejs][:totals]).to eq 0
      end

      context 'when a repository has multiple pull requests in recent date' do
        before do
          create_repository(language: ruby,
                            relevance: internal,
                            last_activity_at: in_effect_date,
                            number_of_prs: 2)
        end

        it 'does not repeat repositories while counting' do
          overview = described_class.call(department, from: from, to: to)

          expect(overview[:ruby][:totals]).to eq 3
        end
      end
    end
  end

  def create_repository(language:, relevance:, last_activity_at:, number_of_prs: 1)
    repository = create(:repository, language: language, relevance: relevance)
    (1..number_of_prs).each do
      create(:pull_request, repository: repository, opened_at: last_activity_at)
    end
  end
end
