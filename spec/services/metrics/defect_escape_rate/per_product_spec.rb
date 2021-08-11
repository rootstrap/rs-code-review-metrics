require 'rails_helper'

describe Metrics::DefectEscapeRate::PerProduct do
  describe '.call' do
    let(:product) { create(:product) }
    let!(:jira_board) { create(:jira_board, product: product) }
    let(:beginning_of_day) { Time.zone.today.beginning_of_day }
    let(:subject) { described_class.call(product.id) }
    let(:defect_rate) { 100 }
    let(:metric) { subject.first }

    context 'when there are bugs for the project' do
      let!(:jira_bugs) do
        create_list(:jira_issue, rand(1..10),
                    :bug,
                    :production,
                    jira_board: jira_board,
                    informed_at: beginning_of_day)
      end

      it 'returns the metrics' do
        expect(subject.count).to eq(1)
      end

      it 'returns the metric ownable id' do
        expect(metric.ownable_id).to eq(product.id)
      end

      it 'returns the metric value timestamp' do
        expect(metric.value_timestamp).to eq(beginning_of_day)
      end

      it 'returns the metric values' do
        expect(metric.value).to eq(defect_rate: defect_rate,
                                   bugs_by_environment: { 'production' => jira_bugs.count })
      end
    end

    context 'when the project has no bugs in the period' do
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
