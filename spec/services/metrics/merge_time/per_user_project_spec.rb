require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerUserProject do
  describe '.call' do
    let(:user_project) { create(:users_project) }
    let(:pull_request) do
      create(:pull_request, state: :open,
                            project_id: user_project.project_id,
                            owner_id: user_project.user_id)
    end

    before { travel_to(Time.zone.today.end_of_day) }

    context 'when processing a collection containing no merged pull requests' do
      it 'does not create a metric' do
        expect { described_class.call }.not_to change { Metric.count }
      end
    end

    context 'when the user has pull requests in one project' do
      context 'and the merge ocurred in a 30 minutes interval' do
        let!(:pull_request) do
          create(:pull_request,
                 opened_at: Time.zone.today.beginning_of_day,
                 project_id: user_project.project_id,
                 owner_id: user_project.user_id)
        end

        before { pull_request.update(merged_at: Time.zone.today.beginning_of_day + 30.minutes) }

        it 'generates a metric with value expressed as decimal equal to 30 minutes' do
          described_class.call
          expect(Metric.last.value.seconds).to eq(30.minutes)
        end

        it 'generates only that metric' do
          expect { described_class.call }.to change { Metric.count }.from(0).to(1)
        end
      end

      context 'when calculating the merge time value' do
        context 'and a user made more than one pull request' do
          let!(:pull_request) do
            create(:pull_request,
                   opened_at: Time.zone.today.beginning_of_day,
                   project_id: user_project.project_id,
                   owner_id: user_project.user_id)
          end

          let!(:second_pull_request) do
            create(:pull_request,
                   opened_at: Time.zone.today.beginning_of_day,
                   project_id: user_project.project_id,
                   owner_id: user_project.user_id)
          end

          let!(:third_pull_request) do
            create(:pull_request,
                   opened_at: Time.zone.today.beginning_of_day,
                   project_id: user_project.project_id,
                   owner_id: user_project.user_id)
          end

          before do
            pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 30.minutes)
            second_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 45.minutes)
            third_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 2.hours)
          end

          it 'creates just one metric' do
            expect { described_class.call }.to change { Metric.count }.from(0).to(1)
          end

          it 'generates a metric with value expressed as decimal equal to 65 minutes' do
            described_class.call
            expect(Metric.first.value.seconds).to eq(65.minutes)
          end
        end
      end
    end

    context 'when a user has merged pull requests in more than one project' do
      let(:same_user_for_second_project) { create(:users_project, user_id: user_project.user_id) }

      let!(:pull_request) do
        create(:pull_request,
               opened_at: Time.zone.today.beginning_of_day,
               project_id: user_project.project_id,
               owner_id: user_project.user_id)
      end

      let!(:second_pull_request) do
        create(:pull_request,
               opened_at: Time.zone.today.beginning_of_day,
               project_id: same_user_for_second_project.project_id,
               owner_id: user_project.user_id)
      end

      before do
        pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 30.minutes)
        second_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 2.hours)
      end

      it 'it generates the metric for the first project' do
        described_class.call
        expect(Metric.first.value.seconds).to eq(30.minutes)
      end

      it 'it generates the metric for the second project' do
        described_class.call
        expect(Metric.second.value.seconds).to eq(2.hours)
      end

      it 'creates two metrics' do
        expect { described_class.call }.to change { Metric.count }.from(0).to(2)
      end
    end

    context 'when has a pull request in another project' do
      let!(:pull_request) do
        create(:pull_request,
               opened_at: Time.zone.today.beginning_of_day,
               project_id: user_project.project_id,
               owner_id: user_project.user_id)
      end

      let!(:second_pull_request) do
        create(:pull_request,
               opened_at: Time.zone.today.beginning_of_day,
               project_id: user_project.project_id,
               owner_id: user_project.user_id)
      end

      let(:second_user_project) do
        create(:users_project, user: user_project.user)
      end

      let!(:third_pull_request) do
        create(:pull_request,
               opened_at: Time.zone.today.beginning_of_day,
               project_id: second_user_project.project_id,
               owner_id: user_project.user_id)
      end

      before do
        pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 20.minutes)
        second_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 30.minutes)
        third_pull_request.update!(merged_at: Time.zone.today.beginning_of_day + 20.minutes)
      end

      it 'generates two metrics' do
        expect { described_class.call }.to change { Metric.count }.from(0).to(2)
      end

      it 'generates a metric with 25 minutes as value' do
        described_class.call
        expect(Metric.first.value.seconds).to eq(25.minutes)
      end

      it 'generates a second metric with 20 minutes as value' do
        described_class.call
        expect(Metric.second.value.seconds).to eq(20.minutes)
      end
    end

    context 'when transaction fails' do
      let(:second_user_project) do
        create(:users_project)
      end

      let!(:review_with_invalid_user_project) do
        create(:pull_request,
               opened_at: Time.zone.today.beginning_of_day,
               project_id: second_user_project.project_id,
               owner_id: user_project.user_id)
      end

      before do
        review_with_invalid_user_project
          .update(merged_at: Time.zone.today.beginning_of_day + 20.minutes)
      end

      it 'creates one metric and then rollbacks the transaction' do
        suppress(NoMethodError) do
          described_class.call
        end

        expect(Metric.count).to eq(0)
      end
    end
  end
end
