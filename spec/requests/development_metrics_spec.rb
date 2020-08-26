require 'rails_helper'

RSpec.describe 'Development Metrics', type: :request do
  describe '#departments' do
    describe 'overview' do
      let(:internal) { Project.relevances[:internal] }
      let(:commercial) { Project.relevances[:commercial] }

      let(:ruby) { Language.find_or_create_by(name: 'ruby') }
      let!(:ruby_internal_project_1) { create(:project, language: ruby, relevance: internal) }
      let!(:ruby_internal_project_2) { create(:project, language: ruby, relevance: internal) }
      let!(:ruby_commercial_project) { create(:project, language: ruby, relevance: commercial) }

      let(:department) { ruby.department.name }

      describe 'language count' do
        it 'renders the total project count for the language' do
          get departments_development_metrics_url,
              params: { department_name: department, metric: { period: 4 } }

          expect(response.body)
            .to include("3 <b>#{ruby.name.titleize}</b> projects")
        end
      end

      describe 'relevance count' do
        it 'renders the each relevance project count' do
          get departments_development_metrics_url,
              params: { department_name: department, metric: { period: 4 } }

          expect(response.body)
            .to include("<b>1</b> #{commercial}", "<b>2</b> #{internal}")
        end
      end
    end
  end
end
