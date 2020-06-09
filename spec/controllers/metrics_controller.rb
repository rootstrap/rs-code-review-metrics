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

      context 'and there is CodeClimate information' do
        before do
          code_climate_metric
        end

        let(:code_climate_metric) do
          create :code_climate_project_metric,
                 project: project, code_climate_rate: 'A',
                 invalid_issues_count: 1,
                 wont_fix_issues_count: 2
        end

        it 'CodeClimate metrics is set to the instance variable @code_climate' do
          expect { get :metrics, params: params }.to change { assigns(:code_climate) }
            .to(code_climate_metric)
        end

        it 'the response has no errors' do
          assert_response :success
        end
      end

      context 'and there is no CodeClimate information' do
        it 'CodeClimate metrics is set to nil' do
          expect { get :metrics, params: params }.not_to change { assigns(:code_climate) }
        end

        it 'the response has no errors' do
          assert_response :success
        end
      end
    end

    context 'when period is not handleable' do
      let(:params) do
        { project_name: project.name, metric: { metric_name: 'merge_time', period: 'monthly' } }
      end
      it 'raises Graph::RangeDateNotSupported' do
        expect {
          get '/development_metrics', params: params
        }.to raise_error(Graph::RangeDateNotSupported)
      end
    end
  end
end
