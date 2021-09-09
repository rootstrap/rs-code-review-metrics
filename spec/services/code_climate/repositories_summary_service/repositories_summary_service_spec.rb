require 'rails_helper'

describe CodeClimate::RepositoriesSummaryService do
  subject { CodeClimate::RepositoriesSummaryService }

  let(:from) { 4 }
  let(:technologies) { %w[] }
  let(:department) { repository_1.language.department }
  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let(:python_lang) { Language.find_by(name: 'python') }
  let(:repository_1) { create :repository, language: ruby_lang, relevance: 'commercial' }
  let(:repository_2) { create :repository, language: python_lang, relevance: 'commercial' }
  let!(:pull_request_1) { create :pull_request, repository: repository_1, opened_at: 2.weeks.ago }
  let!(:pull_request_2) { create :pull_request, repository: repository_2, opened_at: 2.weeks.ago }

  let!(:repositories) do
    create :code_climate_repository_metric,
           repository: repository_1,
           invalid_issues_count: 0,
           wont_fix_issues_count: 0,
           open_issues_count: 0,
           code_climate_rate: 'A',
           snapshot_time: 2.weeks.ago

    create :code_climate_repository_metric,
           repository: repository_2,
           invalid_issues_count: 2,
           wont_fix_issues_count: 4,
           open_issues_count: 6,
           code_climate_rate: 'Z',
           snapshot_time: 2.weeks.ago
  end

  let(:repositories_summary) do
    CodeClimate::RepositoriesSummaryService.call(
      department: department,
      from: from,
      technologies: technologies
    )
  end

  context 'with a department, date from and technologies including repositories' do
    it 'shows the invalid issues count in the selected department' do
      expect(repositories_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(repositories_summary.wont_fix_issues_count_average).to eq(2)
    end

    it 'shows the open issues count in the selected department' do
      expect(repositories_summary.open_issues_count_average).to eq(3)
    end

    it 'shows the total of "A" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('A')).to eq(1)
    end

    it 'shows the total of "C" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('C')).to eq(0)
    end

    it 'shows the total of "Z" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('Z')).to eq(1)
    end
  end

  context 'with a department with no repositories' do
    let(:department) { Department.find_by(name: 'mobile') }

    it 'shows no invalid issues count' do
      expect(repositories_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(repositories_summary.wont_fix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(repositories_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" repositories' do
      expect(repositories_summary.repositories_rated_with('A')).to eq(0)
    end

    it 'shows no total of "Z" repositories' do
      expect(repositories_summary.repositories_rated_with('Z')).to eq(0)
    end
  end

  context 'with no from date' do
    let(:from) { nil }

    it 'shows the invalid issues count in the selected department' do
      expect(repositories_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(repositories_summary.wont_fix_issues_count_average).to eq(2)
    end

    it 'shows the open issues count in the selected department' do
      expect(repositories_summary.open_issues_count_average).to eq(3)
    end

    it 'shows the total of "A" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('A')).to eq(1)
    end

    it 'shows the total of "C" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('C')).to eq(0)
    end

    it 'shows the total of "Z" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('Z')).to eq(1)
    end
  end

  context 'with a from date after the repositories date' do
    let(:from) { 1 }

    it 'shows no invalid issues count' do
      expect(repositories_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(repositories_summary.wont_fix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(repositories_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" repositories' do
      expect(repositories_summary.repositories_rated_with('A')).to eq(0)
    end

    it 'shows no total of "Z" repositories' do
      expect(repositories_summary.repositories_rated_with('Z')).to eq(0)
    end
  end

  context 'with technologies including repositories' do
    it 'shows the invalid issues count in the selected department' do
      expect(repositories_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(repositories_summary.wont_fix_issues_count_average).to eq(2)
    end

    it 'shows the open issues count in the selected department' do
      expect(repositories_summary.open_issues_count_average).to eq(3)
    end

    it 'shows the total of "A" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('A')).to eq(1)
    end

    it 'shows the total of "C" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('C')).to eq(0)
    end

    it 'shows the total of "Z" repositories in the selected department' do
      expect(repositories_summary.repositories_rated_with('Z')).to eq(1)
    end
  end

  context 'with technologies with no repositories' do
    let(:technologies) { %w[ios] }

    it 'shows no invalid issues count' do
      expect(repositories_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(repositories_summary.wont_fix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(repositories_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" repositories' do
      expect(repositories_summary.repositories_rated_with('A')).to eq(0)
    end

    it 'shows no total of "Z" repositories' do
      expect(repositories_summary.repositories_rated_with('Z')).to eq(0)
    end
  end
end
