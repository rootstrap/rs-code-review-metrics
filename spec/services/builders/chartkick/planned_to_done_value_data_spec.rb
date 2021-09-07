require 'rails_helper'

describe Builders::Chartkick::PlannedToDoneValueData do
  subject { described_class.send(:new, 1, '') }

  describe '.build_data' do
    context 'for a given set of metrics' do
      let(:first_week) { Time.zone.today.last_week.beginning_of_week }
      let(:first_week_end) { Time.zone.today.last_week.end_of_week }
      let(:this_week) { Time.zone.today.beginning_of_week }
      let(:this_week_end) { Time.zone.today.end_of_week }

      let(:jira_board) { create(:jira_board, :with_board_id) }

      let(:jira_sprint1) do
        create(:jira_sprint,
               name: 'Sprint 1',
               started_at: first_week,
               ended_at: first_week_end,
               active: false,
               points_committed: 20,
               points_completed: 10,
               jira_board: jira_board)
      end

      let(:jira_sprint2) do
        create(:jira_sprint,
               name: 'Sprint 2',
               started_at: this_week,
               ended_at: this_week_end,
               active: false,
               points_committed: 20,
               points_completed: 10,
               jira_board: jira_board)
      end

      let(:value_for_last_week) do
        {
          planned_to_done_values: [jira_sprint1].pluck(:name, :points_committed, :points_completed)
                                                .map do |name, points_committed, points_completed|
                                                  {
                                                    sprint: name,
                                                    committed: points_committed,
                                                    completed: points_completed
                                                  }
                                                end
        }
      end
      let(:value_for_this_week) do
        {
          planned_to_done_values: [jira_sprint2].pluck(:name, :points_committed, :points_completed)
                                                .map do |name, points_committed, points_completed|
                                                  {
                                                    sprint: name,
                                                    committed: points_committed,
                                                    completed: points_completed
                                                  }
                                                end
        }
      end
      let(:metric_for_last_week) { Metrics::Base::Metric.new(1, first_week, value_for_last_week) }
      let(:metric_for_this_week) { Metrics::Base::Metric.new(1, this_week, value_for_this_week) }
      let(:metrics) { [metric_for_last_week, metric_for_this_week] }

      let(:expected_hash_value) do
        [
          { name: 'Commitment', data: { jira_sprint1.name => jira_sprint1.points_committed } },
          { name: 'Completed', data: { jira_sprint1.name => jira_sprint1.points_completed } },
          { name: 'Commitment', data: { jira_sprint2.name => jira_sprint2.points_committed } },
          { name: 'Completed', data: { jira_sprint2.name => jira_sprint2.points_completed } }
        ]
      end

      it 'returns the expected hash value' do
        expect(subject.build_data(metrics)).to eq(expected_hash_value)
      end
    end
  end
end
