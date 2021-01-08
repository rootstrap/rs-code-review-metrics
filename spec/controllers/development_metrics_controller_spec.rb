require 'rails_helper'

RSpec.describe DevelopmentMetricsController, type: :controller do
  fixtures :departments, :languages

  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let(:project) { create(:project, name: 'rs-metrics', language: ruby_lang) }

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
            period: 'weekly'
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
        allow(Metrics::Group::Weekly).to receive(:call).and_return(true)
        allow(Metrics::Group::Weekly).to receive(:call).and_return(true)
        get :index, params: params

        assert_response :success
      end

      context '#projects' do
        it 'calls CodeClimate summary retriever class' do
          expect(CodeClimateSummaryRetriever).to receive(:call).and_return(code_climate_metric)

          get :projects, params: params
        end
      end

      context '#departments' do
        before { params[:department_name] = project.language.department.name }

        it 'calls CodeClimate summary retriever class' do
          expect(CodeClimate::ProjectsSummaryService)
            .to receive(:call).and_return(code_climate_metric)

          get :departments, params: params
        end
      end
    end
  end
end
