require 'rails_helper'

describe DevelopmentMetricsController, type: :controller do
  fixtures :departments, :languages

  let(:ruby_lang) { Language.find_by(name: 'ruby') }
  let!(:product) { create(:product) }
  let(:repository) do
    create(:repository, name: 'rs-metrics', language: ruby_lang, product: product)
  end
  let!(:jira_board) { create(:jira_board, product: product) }
  let(:beginning_of_day) { Time.zone.today.beginning_of_day }
  let!(:der_metric_definition) { create(:metric_definition, code: :defect_escape_rate) }
  let!(:review_turnaround_metric_definition) do
    create(:metric_definition, code: :review_turnaround)
  end
  let!(:merge_time_metric_metric_definition) { create(:metric_definition, code: :merge_time) }
  let!(:pull_request_size_metric_definition) do
    create(:metric_definition, code: :pull_request_size)
  end

  describe '#index' do
    context 'when metric params are empty' do
      let(:params) { { metric: {} } }

      it 'returns status ok although the absence of content' do
        get :index, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when metric type and dates are valid' do
      let(:params) do
        {
          repository_name: repository.name,
          metric: {
            metric_name: 'review_turnaround',
            from: 4.weeks.ago,
            to: Time.zone.now
          }
        }
      end

      let(:code_climate_metric) do
        create :code_climate_repository_metric,
               repository: repository, code_climate_rate: 'A',
               invalid_issues_count: 1,
               wont_fix_issues_count: 2
      end

      it 'returns status ok' do
        allow(Metrics::Group::Weekly).to receive(:call).and_return(true)

        get :index, params: params

        assert_response :success
      end

      context '#products' do
        render_views

        subject { get :products, params: params }

        context 'when date from is greater than date to' do
          let(:params) do
            {
              product_name: product.name,
              metric: {
                metric_name: 'defect_escape_rate',
                from: 4.weeks.ago,
                to: 5.weeks.ago
              }
            }
          end

          it 'returns status ok' do
            get :index, params: params

            expect(response).to have_http_status(:ok)
          end

          it 'render alert' do
            subject
            expect(response.body).to include('From Date Should Be Less Than To Date')
          end
        end

        context 'when dates are ok' do
          let(:params) do
            {
              product_name: product.name,
              metric: {
                metric_name: 'defect_escape_rate',
                from: 2.years.ago,
                to: Time.zone.now
              }
            }
          end

          context 'when it has issues from different environments' do
            let!(:production_jira_bugs) do
              create_list(:jira_issue, 2,
                          :bug,
                          :production,
                          jira_board: jira_board,
                          informed_at: beginning_of_day)
            end
            let!(:production_jira_bugs_year_ago) do
              create_list(:jira_issue, 2,
                          :bug,
                          :production,
                          jira_board: jira_board,
                          informed_at: 1.year.ago)
            end
            let!(:staging_jira_bugs) do
              create_list(:jira_issue, 1,
                          :bug,
                          :staging,
                          jira_board: jira_board,
                          informed_at: beginning_of_day)
            end
            let!(:qa_jira_bugs) do
              create_list(:jira_issue, 3,
                          :bug,
                          :qa,
                          jira_board: jira_board,
                          informed_at: beginning_of_day)
            end
            let!(:no_env_jira_bugs) do
              create_list(:jira_issue, 2,
                          :bug,
                          :no_environment,
                          jira_board: jira_board,
                          informed_at: beginning_of_day)
            end

            before do
              subject
            end

            it 'has a successful response' do
              expect(response).to be_successful
            end

            it 'render EDR metric with correct production issues' do
              expect(response.body).to include("Production: #{production_jira_bugs.count +
                          production_jira_bugs_year_ago.count}")
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

            it 'render metric name' do
              expect(response.body).to include(der_metric_definition.name)
            end

            it 'render metric tooltip' do
              expect(response.body).to include(der_metric_definition.explanation)
            end
          end
        end
      end

      context '#repositories' do
        render_views

        subject { get :repositories, params: params }

        context 'when date from is greater than date to' do
          let(:params) do
            {
              repository_name: repository.name,
              metric: {
                from: 4.weeks.ago,
                to: 5.weeks.ago
              }
            }
          end

          it 'returns status ok' do
            get :index, params: params

            expect(response).to have_http_status(:ok)
          end

          it 'render alert' do
            subject
            expect(response.body).to include('From Date Should Be Less Than To Date')
          end
        end

        context 'when dates are ok' do
          let(:params) do
            {
              repository_name: repository.name,
              metric: {
                from: 4.weeks.ago,
                to: Time.zone.now
              }
            }
          end

          it 'calls CodeClimate summary retriever class' do
            expect(CodeClimateSummaryRetriever).to receive(:call).and_return(code_climate_metric)
            subject
          end

          it 'render review turnaround metric tooltip' do
            subject
            expect(response.body).to include(review_turnaround_metric_definition.explanation)
          end

          it 'render merge time metric tooltip' do
            subject
            expect(response.body).to include(merge_time_metric_metric_definition.explanation)
          end

          it 'render pull request size metric tooltip' do
            subject
            expect(response.body).to include(pull_request_size_metric_definition.explanation)
          end
        end
      end

      context '#departments' do
        before { params[:department_name] = repository.language.department.name }

        it 'calls CodeClimate summary retriever class' do
          expect(CodeClimate::RepositoriesSummaryService)
            .to receive(:call).and_return(code_climate_metric)

          get :departments, params: params
        end
      end
    end
  end
end
