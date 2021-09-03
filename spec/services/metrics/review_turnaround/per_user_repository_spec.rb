require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerUserRepository do
  describe '.call' do
    let(:ruby_lang)         { Language.find_by(name: 'ruby') }
    let!(:repository)       { create(:repository, language: ruby_lang) }
    let(:beginning_of_day)  { Time.zone.today.beginning_of_day }
    let(:entity_type)       { 'UsersRepository' }
    let(:metric_name)       { :review_turnaround }
    let(:metrics_number)    { 1 }
    let(:user)              { create(:user) }
    let(:subject)           { described_class.call(user.id) }

    context 'when there is available data' do
      before do
        review_request1 = create(:review_request, repository: repository, owner: user)
        review_request2 = create(:review_request, repository: repository, owner: user)
        create(:completed_review_turnaround, review_request: review_request1, value: 1.hour)
        create(:completed_review_turnaround, review_request: review_request2, value: 3.hours)
        create(:users_repository, repository: repository, user: user)
      end

      it_behaves_like 'available metrics data'

      context 'when interval is set' do
        let(:subject) { described_class.call(user.id, interval) }

        before do
          review_request = create(:review_request, repository: repository, owner: user)
          create(:completed_review_turnaround, review_request: review_request,
                                               value: 1.hour, created_at: 5.weeks.ago)
        end

        it_behaves_like 'metric value unchanged'
      end
    end

    it_behaves_like 'unavailable metrics data'
  end
end
