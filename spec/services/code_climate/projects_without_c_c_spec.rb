require 'rails_helper'

describe CodeClimate::ProjectsWithoutCC do
  shared_examples 'returns repository' do
    it 'returns repositories' do
      repositories = subject
      expect(repositories.first).to eq repository
    end
  end

  shared_examples 'does not return repository' do
    it 'does not return the repositories' do
      repositories = subject
      expect(repositories.count).to be_zero
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

    context 'when the repository does not have any cc data associated' do
      let!(:repository) { create :repository, :with_activity, :internal, language: ruby_lang }

      it_behaves_like 'returns repository'
    end

    context 'when the repository does not have cc rate' do
      let(:repository) { create :repository, :with_activity, :internal, language: ruby_lang }

      before do
        create :code_climate_project_metric,
               repository: repository,
               invalid_issues_count: 1,
               wont_fix_issues_count: 2,
               open_issues_count: 3,
               code_climate_rate: nil,
               test_coverage: 97.832,
               snapshot_time: Time.zone.now.ago(10.weeks)
      end

      it_behaves_like 'returns repository'
    end

    context 'when there is a repository with cc data' do
      before do
        create :code_climate_project_metric,
               repository: repository,
               invalid_issues_count: 1,
               wont_fix_issues_count: 2,
               open_issues_count: 3,
               code_climate_rate: 'A',
               test_coverage: 97.832,
               snapshot_time: Time.zone.now.ago(10.weeks)
      end

      context 'and the repository activity is older than requested period' do
        let(:repository) do
          create :repository, :with_activity,
                 :internal,
                 last_activity_in_weeks: 10,
                 language: ruby_lang
        end
        let(:period) { 4 }

        it_behaves_like 'does not return repository'
      end

      context 'and the repository is not relevant' do
        let(:repository) { create :repository, :with_activity, language: ruby_lang }

        it_behaves_like 'does not return repository'
      end
    end
  end
end
