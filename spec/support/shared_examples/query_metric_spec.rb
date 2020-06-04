require 'rails_helper'

RSpec.shared_examples 'query metric' do
  it 'returns the correct number of metrics based on the amount of users in the project' do
    expect(
      described_class.call(entity_name: 'users_project', entity_id: project.id, metric_name: 'review_turnaround').count
    ).to eq(2)
  end

  it 'returns only data with dates between today and the past 14 days' do
    described_class.call(
      entity_name: 'users_project', entity_id: project.id, metric_name: 'review_turnaround'
    ).each do |metric_data|
      metric_data[:data].keys.each do |string_date|
        expect(range).to cover(string_date.to_date)
      end
    end
  end

  it 'returns only the metrics of the users in the given project' do
    described_class.call(
      entity_name: 'users_project', entity_id: project.id, metric_name: 'review_turnaround'
    ).each do |metric_data|
      expect(metric_data[:name]).not_to eq(user_of_another_project.user.login)
    end
  end
end
