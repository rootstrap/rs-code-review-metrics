require 'rails_helper'

RSpec.describe UsersProjectsController, type: :controller do
  context 'when metric params are empty' do
    let(:params) { { metric: {} } }

    it 'returns status ok although the absence of content' do
      get :metrics, params: params

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when metric type and period are valid' do
    it 'returns status ok' do
      allow(Queries::DailyMetrics).to receive(:call).and_return(true)
      get :metrics, params: { project_id: 1,
                              metric_type: 'review_turnaround',
                              period: 'daily' }

      assert_response :success
    end
  end

  context 'when period is not handleable' do
    let(:params) do
      { metric: { project_name: 'rs-metrics', name: 'merge_time', period: 'monthly' } }
    end
    it 'raises Graph::RangeDateNotSupported' do
      expect {
        get :metrics, params: params
      }.to raise_error(Graph::RangeDateNotSupported)
    end
  end
end
