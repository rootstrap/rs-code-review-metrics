require 'rails_helper'

RSpec.describe UsersProjectsController, type: :controller do
  describe '#metrics' do
    before { create(:project, name: 'rs-metrics') }
    context 'when metric params are empty' do
      let(:params) { { metric: {} } }

      it 'returns status ok although the absence of content' do
        get :metrics, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when metric type and period are valid' do
      let(:params) do
        {
          project_name: 'rs-metrics',
          metric: {
            metric_name: 'review_turnaround',
            period: 'daily'
          }
        }
      end

      it 'returns status ok' do
        allow(Queries::DailyMetrics).to receive(:call).and_return(true)
        allow(Queries::DailyMetrics).to receive(:call).and_return(true)
        get :metrics, params: params

        assert_response :success
      end

      it 'calls perdio metric retriever class' do
        expect(Queries::PeriodMetricRetriever).to receive(:call).and_return(Queries::DailyMetrics)

        get :metrics, params: params
      end
    end

    context 'when period is not handleable' do
      let(:params) do
        { project_name: 'rs-metrics', metric: { metric_name: 'merge_time', period: 'monthly' } }
      end
      it 'raises Graph::RangeDateNotSupported' do
        expect {
          get :metrics, params: params
        }.to raise_error(Graph::RangeDateNotSupported)
      end
    end
  end
end
