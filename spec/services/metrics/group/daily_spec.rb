require 'rails_helper'

RSpec.describe Metrics::Group::Daily do
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

    context 'with a given project' do
      before do
        create(:metric, ownable: first_user_project, created_at: Time.zone.now)
        create(:metric, ownable: first_user_project, created_at: Time.zone.now - 1.day)
        create(:metric, ownable: first_user_project, created_at: Time.zone.now - 2.days)

        create(:metric, ownable: second_user_project, created_at: Time.zone.now)
        create(:metric, ownable: second_user_project, created_at: Time.zone.now - 1.day)
        create(:metric, ownable: second_user_project, created_at: Time.zone.now - 2.days)
      end

      let(:range) { (Time.zone.today - 14.days)..Time.zone.today }
      let(:user_of_another_project) { create(:users_project) }

      it_behaves_like 'query metric'
    end
  end
end
