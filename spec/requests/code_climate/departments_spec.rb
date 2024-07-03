require 'rails_helper'

describe 'CodeClimate::DepartmentsController', type: :request do
  describe '#index' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let(:department) { repository.language.department }
    let(:repository) { create :repository, :with_activity, language: ruby_lang }
    let!(:repository_with_no_cc) do
      create :repository, :with_activity, :internal, language: ruby_lang
    end
    let(:test_coverage) { 97.832 }

    before do
      create :code_climate_repository_metric,
             repository: repository,
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
        "CodeClimate report for #{department.name.capitalize} department repositories"
      )
    end

    it 'shows the first repository rate letter' do
      expect(response.body).to include('A')
    end

    it 'shows the first repository invalid issues count' do
      expect(response.body).to include('1 invalid issues')
    end

    it 'shows the first repository invalid issues count' do
      expect(response.body).to include('2 won&#39;t fix issues')
    end

    it 'shows the first repository invalid issues count' do
      expect(response.body).to include('3 open issues')
    end

    it 'shows the first repository test coverage' do
      expect(response.body).to include(test_coverage.round.to_s)
    end

    context 'when the repository does not have test coverage' do
      let(:test_coverage) { nil }

      it 'shows N/D instead' do
        expect(response.body).to include('N/D')
      end
    end

    context 'when there are repositories without CC data' do
      it 'shows the title of a new table' do
        expect(response.body).to include(
          'Repositories without available CodeClimate data for selected time range'
        )
      end

      it 'shows name repository' do
        expect(response.body).to include(repository_with_no_cc.name)
      end
    end
  end
end
