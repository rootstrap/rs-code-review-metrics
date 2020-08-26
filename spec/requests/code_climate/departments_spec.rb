require 'rails_helper'

describe 'CodeClimate department projects report page ', type: :request do
  describe '#index' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let(:department) { project.language.department }
    let(:project) { create :project, language: ruby_lang }
    let(:test_coverage) { 97.832 }

    before do
      create :code_climate_project_metric,
             project: project,
             invalid_issues_count: 1,
             wont_fix_issues_count: 2,
             open_issues_count: 3,
             code_climate_rate: 'A',
             test_coverage: test_coverage,
             snapshot_time: Time.zone.now.ago(1.week)

      get "/development_metrics/code_climate/departments/#{department.name}",
          params: { metric: { period: 4, lang: ['ruby'] } }
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'shows the title' do
      expect(response.body).to include(
        "CodeClimate report for #{department.name} projects Department"
      )
    end

    it 'shows the first project rate letter' do
      expect(response.body).to include('A')
    end

    it 'shows the first project invalid issues count' do
      expect(response.body).to include('1 invalid issues')
    end

    it 'shows the first project invalid issues count' do
      expect(response.body).to include("2 won't fix issues")
    end

    it 'shows the first project invalid issues count' do
      expect(response.body).to include('3 open issues')
    end

    it 'shows the first project test coverage' do
      expect(response.body).to include(test_coverage.round.to_s)
    end

    context 'when the project does not have test coverage' do
      let(:test_coverage) { nil }

      it 'shows N/D instead' do
        expect(response.body).to include('N/D')
      end
    end
  end
end
