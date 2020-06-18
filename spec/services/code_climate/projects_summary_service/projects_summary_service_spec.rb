require 'rails_helper'

describe CodeClimate::ProjectsSummaryService do
  subject { CodeClimate::ProjectsSummaryService }

  let(:departments) { ['web'] }
  let(:from) { DateTime.current }
  let(:technologies) { %w[ruby python] }

  let(:projects_summary) do
    CodeClimate::ProjectsSummaryService.call(
      departments: departments,
      from: from,
      technologies: technologies
    )
  end

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
