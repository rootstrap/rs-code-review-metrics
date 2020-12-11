require 'rails_helper'

describe CodeClimate::ProjectsWithoutCC do
  shared_examples 'returns project' do
    it 'returns project' do
      projects = subject
      expect(projects.first).to eq project
    end
  end

  shared_examples 'does not return project' do
    it 'does not return the project' do
      projects = subject
      expect(projects.count).to be_zero
    end
  end
  describe '.call' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let(:department) { Department.find_by(name: 'backend') }
    let(:period) { 4 }
    let(:subject) do
      CodeClimate::ProjectsWithoutCC.call(department: department,
                                          from: period,
                                          languages: ruby_lang.name)
    end

    context 'when the project does not have any cc data associated' do
      let!(:project) { create :project, :with_activity, :internal, language: ruby_lang }

      it_behaves_like 'returns project'
    end

    context 'when the project does not have cc rate' do
      let(:project) { create :project, :with_activity, :internal, language: ruby_lang }

      before do
        create :code_climate_project_metric,
               project: project,
               invalid_issues_count: 1,
               wont_fix_issues_count: 2,
               open_issues_count: 3,
               code_climate_rate: nil,
               test_coverage: 97.832,
               snapshot_time: Time.zone.now.ago(10.weeks)
      end

      it_behaves_like 'returns project'
    end

    context 'when there is a project with cc data' do
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

      context 'and the project activity is older than requested period' do
        let(:project) do
          create :project, :with_activity,
                 :internal,
                 last_activity_in_weeks: 10,
                 language: ruby_lang
        end
        let(:period) { 4 }

        it_behaves_like 'does not return project'
      end

      context 'and the project is not relevant' do
        let(:project) { create :project, :with_activity, language: ruby_lang }

        it_behaves_like 'does not return project'
      end
    end
  end
end
