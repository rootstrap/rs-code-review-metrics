require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerUserProject do
  describe '.call' do
    let(:user_project) { create(:users_project) }
    let(:pull_request) { create(:pull_request, state: :open, project_id: user_project.project_id) }
    let(:review_request) do
      create(:review_request, pull_request: pull_request, reviewer_id: user_project.user_id)
    end

    context 'when processing a collection containing no review request events' do
      it 'does not create a metric' do
        expect { described_class.call }.not_to change { Metric.count }
      end
    end

    context 'Generating metrics values' do
      context 'when a review comment ocurred in a 30 minutes interval' do
        let!(:review) do
          create(:review,
                 pull_request: pull_request,
                 opened_at: Time.zone.now + 30.minutes,
                 owner: review_request.reviewer)
        end

        it 'generates a metric with value expressed as decimal equal to 30 minutes' do
          described_class.call
          expect(Metric.last.value.seconds).to eq(30.minutes)
        end

        it 'generates only that metric' do
          expect { described_class.call }.to change { Metric.count }.from(0).to(1)
        end
      end

      context 'when calculating the turnaround value' do
        context 'and a user made more than one review in a pull request' do
          let!(:review) do
            create(:review,
                   pull_request: pull_request,
                   opened_at: Time.zone.now,
                   owner: review_request.reviewer)
          end

          let!(:second_review) do
            create(:review,
                   pull_request: pull_request,
                   opened_at: Time.zone.now + 2.hours,
                   owner: review_request.reviewer)
          end

          let!(:third_review) do
            create(:review,
                   pull_request: pull_request,
                   opened_at: Time.zone.now + 4.hours,
                   owner: review_request.reviewer)
          end

          it 'creates just one metric' do
            expect { described_class.call }.to change { Metric.count }.from(0).to(1)
          end
        end
      end
    end

    context 'with a PR that has no reviews' do
      it 'does not generate a metric' do
        expect { described_class }.not_to change { Metric.count }
      end
    end

    context 'when a user has reviews in more than one project' do
      let(:same_user_for_second_project) { create(:users_project, user_id: user_project.user_id) }

      let!(:review) do
        create(:review,
               pull_request: pull_request,
               opened_at: Time.zone.now + 20.minutes,
               owner: review_request.reviewer)
      end

      let(:second_project_pull_request) do
        create(:pull_request, state: :open, project_id: same_user_for_second_project.project_id)
      end

      let(:second_project_review_request) do
        create(
          :review_request,
          pull_request: pull_request,
          reviewer_id: same_user_for_second_project.user_id
        )
      end

      let!(:second_project_review) do
        create(:review,
               pull_request: second_project_pull_request,
               opened_at: Time.zone.now + 45.minutes,
               owner: second_project_review_request.reviewer)
      end

      before { described_class.call }

      it 'it generates the metric for the first project' do
        expect(Metric.first.value.seconds).to eq(20.minutes)
      end

      it 'it generates the metric for the second project' do
        expect(Metric.second.value.seconds).to eq(45.minutes)
      end
    end

    context 'when user has reviews in multiple pull requests' do
      let!(:review) do
        create(:review,
               pull_request: pull_request,
               opened_at: Time.zone.now + 20.minutes,
               owner: review_request.reviewer)
      end

      let(:second_pull_request) do
        create(:pull_request, state: :open, project_id: user_project.project_id)
      end

      let!(:second_review) do
        create(:review,
               pull_request: second_pull_request,
               opened_at: Time.zone.now + 20.minutes,
               owner: review_request.reviewer)
      end

      it 'generates one metric' do
        expect{ described_class.call }.to change{ Metric.count }.from(0).to(1)
      end
    end
  end
end
