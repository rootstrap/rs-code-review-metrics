require 'rails_helper'

describe 'CodeClimate deparment projects report page ', type: :request do
  describe '#index' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let(:department) { project.language.department }
    let(:project) { create :project, language: ruby_lang }

    let!(:request) { get code_climate_department_url(department) }

    it 'shows the title' do
      expect(response.body).to include(
        "CodeClimate report for #{department.name} projects Department"
      )
    end

    describe 'for the first project in the deparment' do
      it 'shows the first project name' do
        expect(response.body).to include('rs-code-review-metrics')
      end

      it 'shows the first project rate letter' do
        expect(response.body).to include('A')
      end

      it 'shows the first project invalid issues count' do
        expect(response.body).to include('11 invalid issues')
      end

      it 'shows the first project invalid issues count' do
        expect(response.body).to include("11 won't fix issues")
      end

      it 'shows the first project invalid issues count' do
        expect(response.body).to include('11 open issues')
      end
    end
  end
end
