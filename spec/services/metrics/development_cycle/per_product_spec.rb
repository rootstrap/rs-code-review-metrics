require 'rails_helper'

describe Metrics::DevelopmentCycle::PerProduct do
  describe '.call' do
    let!(:jira_board) { create(:jira_board) }
    let(:value_timestamp) { '2021-07-30' }
    let(:subject) { described_class.call(jira_board.product.id) }
    let(:average) { 4 }
    let(:metric) { subject.first }

    context 'when there are bugs for the project' do
      before { travel_to Time.zone.parse(value_timestamp) }

      let!(:jira_bugs) do
        create_list(:jira_issue, rand(1..10),
                    :bug,
                    :production,
                    jira_board: jira_board,
                    informed_at: '2021-07-12T15:48:00.000-0300',
                    in_progress_at: '2021-07-26T15:48:04.000-0300',
                    resolved_at: '2021-07-30T15:48:04.000-0300')
      end

      it 'returns the metrics' do
        expect(subject.count).to eq(1)
      end

      it 'returns the metric ownable id' do
        expect(metric.ownable_id).to eq(jira_board.product.id)
      end

      it 'returns the metric value timestamp' do
        expect(metric.value_timestamp).to eq(value_timestamp)
      end

      it 'returns the metric values' do
        expect(metric.value).to eq(development_cycle: average)
      end
    end

    context 'when issue in_progress_at date is nil' do
      let!(:jira_issue) do
        create(:jira_issue,
               informed_at: '2021-07-12T15:48:00.000-0300',
               in_progress_at: nil,
               resolved_at: '2021-07-30T15:48:04.000-0300',
               issue_type: 'task',
               environment: 'development',
               jira_board: jira_board)
      end

      before { travel_to Time.zone.parse(value_timestamp) }

      it 'is not included in the average' do
        expect(subject.count).to eq(0)
      end
    end

    context 'when the project has no bugs in the period' do
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
