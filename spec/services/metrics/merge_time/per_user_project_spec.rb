require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerUserProject do
  describe '.call' do
    let(:ruby_lang)         { Language.find_by(name: 'ruby') }
    let!(:project)          { create(:project, language: ruby_lang) }
    let(:beginning_of_day)  { Time.zone.today.beginning_of_day }
    let(:entity_type)       { 'UsersProject' }
    let(:metric_name)       { :merge_time }
    let(:metrics_number)    { 1 }
    let(:user)              { create(:user) }
    let(:subject)           { described_class.call(user.id) }

    context 'when there is available data' do
      before do
        pr1 = create(:pull_request, project: project,
                                    owner: user,
                                    merged_at: beginning_of_day + 1.hour)
        pr2 = create(:pull_request, project: project,
                                    owner: user,
                                    merged_at: beginning_of_day + 3.hours)
        create(:merge_time, pull_request: pr1, value: 1.hour.seconds)
        create(:merge_time, pull_request: pr2, value: 3.hours.seconds)
        create(:users_project, project: project, user: user)
      end

      it_behaves_like 'available metrics data'
    end

    it_behaves_like 'unavailable metrics data'
  end
end
