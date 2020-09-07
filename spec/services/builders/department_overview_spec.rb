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

    let(:department) { ruby.department }
    let(:date) { 4.weeks.ago }

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
    end
  end

  def create_project(language:, relevance:, last_activity_at:)
    project = create(:project, language: language, relevance: relevance)
    create(:pull_request, project: project, opened_at: last_activity_at)
  end
end
