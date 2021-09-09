require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerUserRepository do
  describe '.call' do
    let(:ruby_lang)         { Language.find_by(name: 'ruby') }
    let!(:repository)       { create(:repository, language: ruby_lang) }
    let(:beginning_of_day)  { Time.zone.today.beginning_of_day }
    let(:entity_type)       { 'UsersRepository' }
    let(:metric_name)       { :merge_time }
    let(:metrics_number)    { 1 }
    let(:user)              { create(:user) }
    let(:subject)           { described_class.call(user.id) }

    context 'when there is available data' do
      before do
        pull_request1 = create(:pull_request, repository: repository,
                                              owner: user,
                                              merged_at: beginning_of_day + 1.hour)
        pull_request2 = create(:pull_request, repository: repository,
                                              owner: user,
                                              merged_at: beginning_of_day + 3.hours)
        create(:merge_time, pull_request: pull_request1, value: 1.hour.seconds)
        create(:merge_time, pull_request: pull_request2, value: 3.hours.seconds)
        create(:users_repository, repository: repository, user: user)
      end

      it_behaves_like 'available metrics data'

      context 'when interval is set' do
        let(:subject) { described_class.call(user.id, interval) }

        before do
          pull_request = create(:pull_request, repository: repository, owner: user,
                                               merged_at: 5.weeks.ago)
          create(:merge_time, pull_request: pull_request, value: 1.hour.seconds)
        end

        it_behaves_like 'metric value unchanged'
      end
    end

    it_behaves_like 'unavailable metrics data'
  end
end
