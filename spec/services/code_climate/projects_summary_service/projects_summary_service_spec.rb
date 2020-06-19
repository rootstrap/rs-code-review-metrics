require 'rails_helper'

describe CodeClimate::ProjectsSummaryService do
  subject { CodeClimate::ProjectsSummaryService }

  let(:department) { 'web' }
  let(:from) { DateTime.parse('2020-06-02') }
  let(:technologies) { %w[ruby python] }

  let!(:projects) do
    project_1 = create :project
    project_2 = create :project

    create :code_climate_project_metric,
           project: project_1,
           invalid_issues_count: 0,
           wont_fix_issues_count: 0,
           open_issues_count: 0,
           code_climate_rate: 'A',
           snapshot_time: DateTime.parse('2020-06-02')

    create :code_climate_project_metric,
           project: project_2,
           invalid_issues_count: 2,
           wont_fix_issues_count: 4,
           open_issues_count: 6,
           code_climate_rate: 'Z',
           snapshot_time: DateTime.parse('2020-06-03')
  end

  let(:projects_summary) do
    CodeClimate::ProjectsSummaryService.call(
      department: department,
      from: from,
      technologies: technologies
    )
  end

  context 'for a department' do
    it 'shows the invalid issues count in the selected department' do
      expect(projects_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(projects_summary.wontfix_issues_count_average).to eq(2)
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

  context 'for other department than the selected one' do
    let(:department) { 'mobile' }

    it 'shows no invalid issues count' do
      expect(projects_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(projects_summary.wontfix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(projects_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" projects' do
      expect(projects_summary.projects_rated_with('A')).to be_nil
    end

    it 'shows no total of "Z" projects' do
      expect(projects_summary.projects_rated_with('Z')).to be_nil
    end
  end

  context 'for from a date previous to the projects date' do
    it 'shows the invalid issues count in the selected department' do
      expect(projects_summary.invalid_issues_count_average).to eq(1)
    end

    it 'shows the wontfix issues count in the selected department' do
      expect(projects_summary.wontfix_issues_count_average).to eq(2)
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

  context 'for a from date after the projects date' do
    let(:from) { DateTime.parse('2020-06-04') }

    it 'shows no invalid issues count' do
      expect(projects_summary.invalid_issues_count_average).to be_nil
    end

    it 'shows no wontfix issues count' do
      expect(projects_summary.wontfix_issues_count_average).to be_nil
    end

    it 'shows no open issues count' do
      expect(projects_summary.open_issues_count_average).to be_nil
    end

    it 'shows no total of "A" projects' do
      expect(projects_summary.projects_rated_with('A')).to be_nil
    end

    it 'shows no total of "Z" projects' do
      expect(projects_summary.projects_rated_with('Z')).to be_nil
    end
  end
end
