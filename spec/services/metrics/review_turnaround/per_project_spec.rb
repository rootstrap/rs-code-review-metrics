require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerProject do
  describe '.call' do
    let(:user_project) { create(:users_project) }
    let(:pull_request) { create(:pull_request, state: :open, project_id: user_project.project_id) }
    let(:review_request) do
      create(:review_request, pull_request: pull_request, reviewer_id: user_project.user_id)
    end
    let(:current_time) { Time.zone.now }

    before { travel_to(Time.zone.today.beginning_of_day) }

    context 'when processing a collection containing no review events' do
      it 'does not create a metric' do
        expect { described_class.call }.not_to change { Metric.count }
      end
    end

    context 'Generating metrics values' do
      context 'when a project has 30 minutes of review turnaround' do
        let!(:first_review) do
          create(:review,
                  pull_request: pull_request,
                  opened_at: 30.minutes.from_now(current_time),
                  project: user_project.project,
                  owner: review_request.reviewer)
        end

        let!(:second_review) do
          create(:review,
                  pull_request: pull_request,
                  opened_at: 30.minutes.from_now(current_time),
                  project: user_project.project,
                  owner: review_request.reviewer)
        end

        it 'generates a metric with value expressed as decimal equal to 30 minutes' do
          described_class.call
          expect(Metric.first.value.seconds).to eq(30.minutes)
        end

        it 'generates only that metric' do
          expect { described_class.call }.to change { Metric.count }.from(0).to(1)
        end
      end

      context 'when there are multiple projects with reviews' do
        let(:second_user_project) { create(:users_project) }
        let(:third_user_project) { create(:users_project) }
        let!(:review) do
          create(:review,
                  pull_request: pull_request,
                  opened_at: current_time,
                  project: user_project.project,
                  owner: review_request.reviewer)
        end

        let!(:second_review) do
          create(:review,
                  pull_request: pull_request,
                  opened_at: 2.hours.from_now(current_time),
                  project: second_user_project.project,
                  owner: review_request.reviewer)
        end

        let!(:third_review) do
          create(:review,
                  pull_request: pull_request,
                  opened_at: 4.hours.from_now(current_time),
                  project: third_user_project.project,
                  owner: review_request.reviewer)
        end

        it 'creates three metrics' do
          expect { described_class.call }.to change { Metric.count }.from(0).to(3)
        end

        describe 'reviews from different users' do
          let(:second_review_request) do
            create(:review_request, pull_request: pull_request, reviewer_id: second_user_project.user_id)
          end
          let(:third_review_request) do
            create(:review_request, pull_request: pull_request, reviewer_id: third_user_project.user_id)
          end
          let!(:fourth_review) do
            create(:review,
                    pull_request: pull_request,
                    opened_at: current_time,
                    project: second_user_project.project,
                    owner: second_review_request.reviewer)
          end
  
          let!(:fifth_review) do
            create(:review,
                    pull_request: pull_request,
                    opened_at: 2.hours.from_now(current_time),
                    project: third_user_project.project,
                    owner: third_review_request.reviewer)
          end

          before { described_class.call }

          it 'creates one metric' do
            expect(Metric.count).to eq(3)
          end

          it 'has value of 3 hours' do
            expect(Metric.third.value.seconds).to eq(3.hours)
          end
        end
      end
    end
  end
end
