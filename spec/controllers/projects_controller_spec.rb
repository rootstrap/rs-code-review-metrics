require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  context 'when metric type is invalid' do
    it 'returns status not found' do
      get :user_project_metric, params: { project_id: 1, metric_type: 'rootstrap' }

      assert_response :not_found
    end
  end

  context 'when metric type is valid' do
    it 'returns status ok' do
      allow(Queries::DailyMetrics).to receive(:call).and_return(true)
      get :user_project_metric, params: { project_id: 1, metric_type: 'review_turnaround' }

      assert_response :success
    end
  end
end
