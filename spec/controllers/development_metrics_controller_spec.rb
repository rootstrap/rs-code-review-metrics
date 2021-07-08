require 'rails_helper'

describe DevelopmentMetricsController, type: :controller do
  fixtures :departments, :languages

  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let(:product) { create(:product) }
  let(:project) { create(:project, name: 'rs-metrics', language: ruby_lang, product: product) }
  let!(:jira_project) { create(:jira_project, product: product) }
  let(:beginning_of_day) { Time.zone.today.beginning_of_day }

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

        get :index, params: params

        assert_response :success
      end

      context '#projects' do
        render_views

        subject { get :projects, params: params }

        let(:params) do
          {
            project_name: project.name,
            metric: {
              metric_name: 'defect_escape_rate',
              period: 'weekly'
            }
          }
        end

        it 'calls CodeClimate summary retriever class' do
          expect(CodeClimateSummaryRetriever).to receive(:call).and_return(code_climate_metric)

          subject
        end

        context 'when it has issues from different environments' do
          let!(:production_jira_bugs) do
            create_list(:jira_issue, 2,
                        :bug,
                        :production,
                        jira_project: jira_project,
                        informed_at: beginning_of_day)
          end
          let!(:staging_jira_bugs) do
            create_list(:jira_issue, 1,
                        :bug,
                        :staging,
                        jira_project: jira_project,
                        informed_at: beginning_of_day)
          end
          let!(:qa_jira_bugs) do
            create_list(:jira_issue, 3,
                        :bug,
                        :qa,
                        jira_project: jira_project,
                        informed_at: beginning_of_day)
          end
          let!(:no_env_jira_bugs) do
            create_list(:jira_issue, 2,
                        :bug,
                        :no_environment,
                        jira_project: jira_project,
                        informed_at: beginning_of_day)
          end

          before do
            subject
          end

          it 'has a successful response' do
            expect(response).to be_successful
          end

          it 'render EDR metric with correct production issues' do
            expect(response.body).to include("Production: #{production_jira_bugs.count}")
          end

          it 'render EDR metric with correct staging issues' do
            expect(response.body).to include("Staging: #{staging_jira_bugs.count}")
          end

          it 'render EDR metric with correct QA issues' do
            expect(response.body).to include("Qa: #{qa_jira_bugs.count}")
          end

          it 'render EDR metric with correct issues when no environment defined' do
            expect(response.body).to include("None: #{no_env_jira_bugs.count}")
          end
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
