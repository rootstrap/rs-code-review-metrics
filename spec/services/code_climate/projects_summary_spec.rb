require 'rails_helper'

describe CodeClimate::ProjectsSummary do
  subject do
    CodeClimate::ProjectsSummary.new(
      invalid_issues_count_average: 1,
      wontfix_issues_count_average: 2,
      open_issues_count_average: 3,
      ratings: {
        'A' => 1,
        'B' => 2
      }
    )
  end

  it 'gets the invalid_issues_count_average' do
    expect(subject.invalid_issues_count_average).to eq(1)
  end

  it 'gets the invalid_issues_count_average' do
    expect(subject.wontfix_issues_count_average).to eq(2)
  end

  it 'gets the invalid_issues_count_average' do
    expect(subject.open_issues_count_average).to eq(3)
  end

  it 'gets the number of projects rated with a given rate' do
    expect(subject.projects_rated_with('A')).to eq(1)
  end

  it 'gets the number of projects rated with an absent rate' do
    expect(subject.projects_rated_with('C')).to eq(0)
  end

  it 'iterates the project rates count' do
    rates_conter = {}
    subject.each_project_rate do |rate, count|
      rates_conter[rate] = count
    end
    expect(rates_conter).to eq('A' => 1, 'B' => 2)
  end
end
