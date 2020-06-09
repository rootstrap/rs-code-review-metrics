require 'rails_helper'

RSpec.describe MetricsController, type: :request do
  describe '#index' do
    before { create(:project, name: 'rs-metrics') }
    context 'when metric params are empty' do
      let(:params) { { metric: {} } }

      it 'returns status ok although the absence of content' do
        get '/development_metrics', params: params

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
        allow(Metrics::Group::Daily).to receive(:call).and_return(true)
        allow(Metrics::Group::Daily).to receive(:call).and_return(true)
        get '/development_metrics', params: params

        assert_response :success
      end

      it 'calls perdio metric retriever class' do
        expect(Metrics::PeriodRetriever).to receive(:call).and_return(Metrics::Group::Daily)

        get '/development_metrics', params: params
      end
    end

    context 'when period is not handleable' do
      let(:params) do
        { project_name: 'rs-metrics', metric: { metric_name: 'merge_time', period: 'monthly' } }
      end
      it 'raises Graph::RangeDateNotSupported' do
        expect {
          get '/development_metrics', params: params
        }.to raise_error(Graph::RangeDateNotSupported)
      end
    end
  end
end
