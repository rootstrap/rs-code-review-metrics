require 'rails_helper'

describe CodeClimate::ProjectsSummaryService do
  subject { CodeClimate::ProjectsSummaryService }

  let(:from) { 4 }
  let(:technologies) { %w[] }
  let(:department) { project_1.language.department }
  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let(:python_lang) { Language.find_by(name: 'python') }
  let(:project_1) { create :project, language: ruby_lang, relevance: 'commercial' }
  let(:project_2) { create :project, language: python_lang, relevance: 'commercial' }
  let!(:pull_request_1) { create :pull_request, project: project_1, opened_at: 2.weeks.ago }
  let!(:pull_request_2) { create :pull_request, project: project_2, opened_at: 2.weeks.ago }

  let!(:projects) do
    create :code_climate_project_metric,
           project: project_1,
           invalid_issues_count: 0,
           wont_fix_issues_count: 0,
           open_issues_count: 0,
           code_climate_rate: 'A',
           snapshot_time: 2.weeks.ago

    create :code_climate_project_metric,
           project: project_2,
           invalid_issues_count: 2,
           wont_fix_issues_count: 4,
           open_issues_count: 6,
           code_climate_rate: 'Z',
           snapshot_time: 2.weeks.ago
  end

  let(:projects_summary) do
    CodeClimate::ProjectsSummaryService.call(
      department: department,
      from: from,
      technologies: technologies
    )
  end

  context 'with a department, date from and technologies including projects' do
    it 'shows the invalid issues count in the selected department' do
      expect(projects_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(projects_summary.wont_fix_issues_count_average).to eq(2)
    end

    it 'shows the open issues count in the selected department' do
      expect(projects_summary.open_issues_count_average).to eq(3)
    end

    it 'shows the total of "A" projects in the selected department' do
      expect(projects_summary.projects_rated_with('A')).to eq(1)
    end

    it 'shows the total of "C" projects in the selected department' do
      expect(projects_summary.projects_rated_with('C')).to eq(0)
    end

    it 'shows the total of "Z" projects in the selected department' do
      expect(projects_summary.projects_rated_with('Z')).to eq(1)
    end
  end

  context 'with a department with no projects' do
    let(:department) { Department.find_by(name: 'mobile') }

    it 'shows no invalid issues count' do
      expect(projects_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(projects_summary.wont_fix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(projects_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" projects' do
      expect(projects_summary.projects_rated_with('A')).to eq(0)
    end

    it 'shows no total of "Z" projects' do
      expect(projects_summary.projects_rated_with('Z')).to eq(0)
    end
  end

  context 'with no from date' do
    let(:from) { nil }

    it 'shows the invalid issues count in the selected department' do
      expect(projects_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(projects_summary.wont_fix_issues_count_average).to eq(2)
    end

    it 'shows the open issues count in the selected department' do
      expect(projects_summary.open_issues_count_average).to eq(3)
    end

    it 'shows the total of "A" projects in the selected department' do
      expect(projects_summary.projects_rated_with('A')).to eq(1)
    end

    it 'shows the total of "C" projects in the selected department' do
      expect(projects_summary.projects_rated_with('C')).to eq(0)
    end

    it 'shows the total of "Z" projects in the selected department' do
      expect(projects_summary.projects_rated_with('Z')).to eq(1)
    end
  end

  context 'with a from date after the projects date' do
    let(:from) { 1 }

    it 'shows no invalid issues count' do
      expect(projects_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(projects_summary.wont_fix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(projects_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" projects' do
      expect(projects_summary.projects_rated_with('A')).to eq(0)
    end

    it 'shows no total of "Z" projects' do
      expect(projects_summary.projects_rated_with('Z')).to eq(0)
    end
  end

  context 'with technologies including projects' do
    it 'shows the invalid issues count in the selected department' do
      expect(projects_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(projects_summary.wont_fix_issues_count_average).to eq(2)
    end

    it 'shows the open issues count in the selected department' do
      expect(projects_summary.open_issues_count_average).to eq(3)
    end

    it 'shows the total of "A" projects in the selected department' do
      expect(projects_summary.projects_rated_with('A')).to eq(1)
    end

    it 'shows the total of "C" projects in the selected department' do
      expect(projects_summary.projects_rated_with('C')).to eq(0)
    end

    it 'shows the total of "Z" projects in the selected department' do
      expect(projects_summary.projects_rated_with('Z')).to eq(1)
    end
  end

  context 'with technologies with no projects' do
    let(:technologies) { %w[ios] }

    it 'shows no invalid issues count' do
      expect(projects_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(projects_summary.wont_fix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(projects_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" projects' do
      expect(projects_summary.projects_rated_with('A')).to eq(0)
    end

    it 'shows no total of "Z" projects' do
      expect(projects_summary.projects_rated_with('Z')).to eq(0)
    end
  end
end
