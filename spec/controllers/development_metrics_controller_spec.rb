require 'rails_helper'

RSpec.describe DevelopmentMetricsController, type: :controller do
  let(:project) { create(:project, name: 'rs-metrics') }

  describe '#index' do
    context 'when metric params are empty' do
      let(:params) { { metric: {} } }

      it 'returns status ok although the absence of content' do
        get :index, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when metric type and period are valid' do
      let(:params) do
        {
          project_name: project.name,
          metric: {
            metric_name: 'review_turnaround',
            period: 'daily'
          }
        }
      end
      let(:code_climate_metric) do
        create :code_climate_project_metric,
               project: project, code_climate_rate: 'A',
               invalid_issues_count: 1,
               wont_fix_issues_count: 2
      end

      it 'returns status ok' do
        allow(Metrics::Group::Daily).to receive(:call).and_return(true)
        allow(Metrics::Group::Daily).to receive(:call).and_return(true)
        get :index, params: params

        assert_response :success
      end

      it 'calls period metric retriever class' do
        expect(Metrics::PeriodRetriever).to receive(:call).and_return(Metrics::Group::Daily)

        get :index, params: params
      end

      it 'calls CodeClimate summary retriever class' do
        expect(CodeClimateSummaryRetriever).to receive(:call).and_return(code_climate_metric)

        get :index, params: params
      end
    end

    context 'when period is not handleable' do
      let(:params) do
        { project_name: project.name, metric: { metric_name: 'merge_time', period: 'monthly' } }
      end
      it 'raises Graph::RangeDateNotSupported' do
        expect {
          get :index, params: params
        }.to raise_error(Graph::RangeDateNotSupported)
      end
    end
  end
end
