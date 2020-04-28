require 'rails_helper'

RSpec.describe Queries::DailyMetrics do
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
        create(:metric, ownable: first_user_project, created_at: Time.zone.now - 1.days)
        create(:metric, ownable: first_user_project, created_at: Time.zone.now - 2.days)

        create(:metric, ownable: second_user_project, created_at: Time.zone.now)
        create(:metric, ownable: second_user_project, created_at: Time.zone.now - 1.days)
        create(:metric, ownable: second_user_project, created_at: Time.zone.now - 2.days)
      end

      let(:range) { (Time.zone.today - 14.days)..Time.zone.today }
      let(:user_of_another_project) { create(:users_project) }


      it 'returns the correct number of metrics based the amount of user in the project' do
        expect(described_class.call(project.id).count).to eq(2)
      end

      it 'returns only data with dates between today and the past 14 days' do
        described_class.call(project.id).each do |metric_data|
          metric_data[:data].keys.each do |string_date|
            expect(range).to cover(string_date.to_date)
          end
        end
      end

      it 'returns only the metrics of the users in the given project' do
        described_class.call(project.id).each do |metric_data|
          expect(metric_data[:name]).not_to eq(user_of_another_project.user.login)
        end
      end
    end
  end
end
