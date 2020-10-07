require 'rails_helper'

RSpec.describe Builders::DepartmentOverview do
  describe '.call' do
    let(:internal) { Project.relevances[:internal] }
    let(:commercial) { Project.relevances[:commercial] }
    let(:ignored) { Project.relevances[:ignored] }
    let(:unassigned) { Project.relevances[:unassigned] }

    let(:ruby) { Language.find_or_create_by(name: 'ruby') }
    let(:python) { Language.find_or_create_by(name: 'python') }
    let!(:nodejs) { Language.find_or_create_by(name: 'nodejs') }

    let(:outdated_date) { date.yesterday }
    let(:in_effect_date) { date.tomorrow }

    let(:date) { 4.weeks.ago }

    let(:department) { ruby.department }

    before do
      # counted projects
      create_project(language: ruby, relevance: internal, last_activity_at: in_effect_date)
      create_project(language: ruby, relevance: commercial, last_activity_at: in_effect_date)

      create_project(language: python, relevance: internal, last_activity_at: in_effect_date)
      create_project(language: python, relevance: internal, last_activity_at: in_effect_date)

      # not counted projects
      create_project(language: ruby, relevance: unassigned, last_activity_at: in_effect_date)
      create_project(language: ruby, relevance: internal, last_activity_at: outdated_date)

      create_project(language: python, relevance: ignored, last_activity_at: in_effect_date)
    end

    describe 'count by relevance' do
      it 'returns the amount of projects by language and relevance' do
        overview = described_class.call(department, from: date)

        expect(overview[:ruby][:per_relevance][:internal]).to eq 1
        expect(overview[:ruby][:per_relevance][:commercial]).to eq 1
        expect(overview[:python][:per_relevance][:internal]).to eq 2
        expect(overview[:python][:per_relevance][:commercial]).to eq 0
        expect(overview[:nodejs][:per_relevance][:internal]).to eq 0
        expect(overview[:nodejs][:per_relevance][:commercial]).to eq 0
      end

      it 'does not count any ignored or unassigned project' do
        overview = described_class.call(department, from: date)

        expect(overview[:ruby][:per_relevance][:unassigned]).not_to be_present
        expect(overview[:python][:per_relevance][:ignored]).not_to be_present
      end
    end

    describe 'total count' do
      it 'returns the totals for each language' do
        overview = described_class.call(department, from: date)

        expect(overview[:ruby][:totals]).to eq 2
        expect(overview[:python][:totals]).to eq 2
        expect(overview[:nodejs][:totals]).to eq 0
      end

      context 'when a project has multiple pull requests in recent date' do
        before do
          create_project(language: ruby,
                         relevance: internal,
                         last_activity_at: in_effect_date,
                         number_of_prs: 2)
        end

        it 'does not repeat projects while counting' do
          overview = described_class.call(department, from: date)

          expect(overview[:ruby][:totals]).to eq 3
        end
      end
    end
  end

  def create_project(language:, relevance:, last_activity_at:, number_of_prs: 1)
    project = create(:project, language: language, relevance: relevance)
    (1..number_of_prs).each do
      create(:pull_request, project: project, opened_at: last_activity_at)
    end
  end
end
