require 'rails_helper'

describe 'CodeClimate deparment projects report page ', type: :request do
  describe '#index' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let(:department) { project.language.department }
    let(:project) { create :project, language: ruby_lang }

    let!(:request) { get code_climate_department_url(department) }

    let!(:projects) do
      create :code_climate_project_metric,
             project: project,
             invalid_issues_count: 1,
             wont_fix_issues_count: 2,
             open_issues_count: 3,
             code_climate_rate: 'A',
             snapshot_time: DateTime.parse('2020-06-02')
    end

    it 'shows the title' do
      expect(response.body).to include(
        "CodeClimate report for #{department.name} projects Department"
      )
    end

    # These need to be implemented
    describe 'for the first project in the deparment' do
      xit 'shows the first project name' do
        expect(response.body).to include(project.name)
      end

      xit 'shows the first project rate letter' do
        expect(response.body).to include('A')
      end

      xit 'shows the first project invalid issues count' do
        expect(response.body).to include('1 invalid issues')
      end

      xit 'shows the first project invalid issues count' do
        expect(response.body).to include("2 won't fix issues")
      end

      xit 'shows the first project invalid issues count' do
        expect(response.body).to include('3 open issues')
      end
    end
  end
end
