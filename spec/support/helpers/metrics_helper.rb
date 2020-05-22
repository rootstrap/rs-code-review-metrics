require 'rails_helper'

module MetricsHelper
  def generate_metrics(metric_type, users_projects_amount:, metrics_amount_per_user_project:)
    project = create(:project, name: 'rs-code-review-metrics')

    users_projects_amount.times do
      user = create(:user)
      user_project = create(:users_project, user_id: user.id, project_id: project.id)

      metrics_amount_per_user_project.times do |i|
        create(:metric, ownable: user_project, created_at: Time.zone.now - i.day, name: metric_type)
      end
    end
  end
end
