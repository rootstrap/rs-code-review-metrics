require 'rails_helper'

RSpec.describe Queries::DailyMetrics do
  describe '.call' do
    context 'when metric type is review turnaround' do
      before do
        generate_metrics('review_turnaround', users_projects_amount: 2,
                                              metrics_amount_per_user_project: 3)
      end
      include_examples 'user project example', 'review_turnaround'
    end

    context 'when metric type is merge time' do
      before do
        generate_metrics('merge_time', users_projects_amount: 2,
                                       metrics_amount_per_user_project: 3)
      end
      include_examples 'user project example', 'merge_time'
    end
  end
end
