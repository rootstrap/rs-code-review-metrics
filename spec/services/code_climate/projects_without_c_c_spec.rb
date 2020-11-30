require 'rails_helper'

describe CodeClimate::ProjectsWithoutCC do
  describe '.call' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let(:department) { Department.find_by(name: 'backend') }
    let(:period) { 4 }
    let(:subject) do
      CodeClimate::ProjectsWithoutCC.call(department: department,
                                          from: period,
                                          languages: ruby_lang.name)
    end

    context 'when there is a project without any cc data' do
      let!(:project_with_no_cc) { create :project, language: ruby_lang }

      it 'returns project with no-cc data' do
        projects = subject
        expect(projects.first).to eq project_with_no_cc
      end
    end

    context 'when there is a project with outdated cc data for the given time range' do
      let(:project) { create :project, language: ruby_lang }
      let(:period) { 2 }

      before do
        create :code_climate_project_metric,
               project: project,
               invalid_issues_count: 1,
               wont_fix_issues_count: 2,
               open_issues_count: 3,
               code_climate_rate: 'A',
               test_coverage: 97.832,
               snapshot_time: Time.zone.now.ago(10.weeks)
      end

      it 'returns project' do
        projects = subject
        expect(projects.first).to eq project
      end
    end
  end
end
