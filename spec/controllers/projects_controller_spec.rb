require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  context 'when metric type is invalid' do
    it 'returns status not found' do
      get :user_project_metric, params: { project_id: 1, metric_type: 'rootstrap' }

      assert_response :not_found
    end
  end

  context 'when metric type and period are valid' do
    it 'returns status ok' do
      allow(Queries::DailyMetrics).to receive(:call).and_return(true)
      get :user_project_metric, params: { project_id: 1,
                                          metric_type: 'review_turnaround',
                                          period: 'daily' }

      assert_response :success
    end
  end

  context 'when period is not handleable' do
    it 'raises Graph::RangeDateNotSupported' do
      expect {
        get :user_project_metric, params: { project_id: 1,
                                            metric_type: 'review_turnaround',
                                            period: 'monthly' }
      }.to raise_error(Graph::RangeDateNotSupported)
    end
  end
end
