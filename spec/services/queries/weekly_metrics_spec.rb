require 'rails_helper'

RSpec.describe Metrics::Group::Weekly do
  describe '.call' do
    let(:project) { create(:project, name: 'rs-code-review-metrics') }

    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }

    let(:first_user_project) do
      create(:users_project, user_id: first_user.id, project_id: project.id)
    end

    let(:second_user_project) do
      create(:users_project, user_id: second_user.id, project_id: project.id)
    end

    let(:beginning_of_this_week) do
      Time.zone.today.beginning_of_week
    end

    context 'with a given project' do
      let(:user_of_another_project) { create(:users_project) }
      let(:range) { ((Time.zone.today - 4.weeks).beginning_of_week)..Time.zone.today.end_of_week }

      before do
        create(:weekly_metric,
               ownable: first_user_project,
               value_timestamp: beginning_of_this_week)
        create(:weekly_metric,
               ownable: first_user_project,
               value_timestamp: beginning_of_this_week - 1.week)
        create(:weekly_metric,
               ownable: first_user_project,
               value_timestamp: beginning_of_this_week - 2.weeks)

        create(:weekly_metric,
               ownable: second_user_project,
               value_timestamp: beginning_of_this_week)
        create(:weekly_metric,
               ownable: second_user_project,
               value_timestamp: beginning_of_this_week - 1.week)
        create(:weekly_metric,
               ownable: second_user_project,
               value_timestamp: beginning_of_this_week - 2.weeks)
      end

      it_behaves_like 'query metric'
    end
  end
end
