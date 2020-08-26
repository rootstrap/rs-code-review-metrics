require 'rails_helper'

RSpec.describe Builders::DepartmentOverview do
  describe '.call' do
    let(:internal) { Project.relevances[:internal] }
    let(:commercial) { Project.relevances[:commercial] }
    let(:ignored) { Project.relevances[:ignored] }
    let(:unassigned) { Project.relevances[:unassigned] }

    let(:ruby) { Language.find_or_create_by(name: 'ruby') }
    let!(:ruby_internal_project) { create(:project, language: ruby, relevance: internal) }
    let!(:ruby_commercial_project) { create(:project, language: ruby, relevance: commercial) }
    let!(:ruby_unassigned_project) { create(:project, language: ruby, relevance: unassigned) }

    let(:python) { Language.find_or_create_by(name: 'python') }
    let!(:python_internal_project_1) { create(:project, language: python, relevance: internal) }
    let!(:python_internal_project_2) { create(:project, language: python, relevance: internal) }
    let!(:python_ignored_project) { create(:project, language: python, relevance: ignored) }

    let!(:nodejs) { Language.find_or_create_by(name: 'nodejs') }

    let(:department) { ruby.department }

    describe 'count by relevance' do
      it 'returns the amount of projects by language and relevance' do
        overview = described_class.call(department)

        expect(overview[:ruby][:per_relevance][:internal]).to eq 1
        expect(overview[:ruby][:per_relevance][:commercial]).to eq 1
        expect(overview[:python][:per_relevance][:internal]).to eq 2
        expect(overview[:python][:per_relevance][:commercial]).to eq 0
        expect(overview[:nodejs][:per_relevance][:internal]).to eq 0
        expect(overview[:nodejs][:per_relevance][:commercial]).to eq 0
      end

      it 'does not count any ignored or unassigned project' do
        overview = described_class.call(department)

        expect(overview[:ruby][:per_relevance][:unassigned]).not_to be_present
        expect(overview[:python][:per_relevance][:ignored]).not_to be_present
      end
    end

    describe 'total count' do
      it 'returns the totals for each language' do
        overview = described_class.call(department)

        expect(overview[:ruby][:totals]).to eq 2
        expect(overview[:python][:totals]).to eq 2
        expect(overview[:nodejs][:totals]).to eq 0
      end
    end
  end
end
