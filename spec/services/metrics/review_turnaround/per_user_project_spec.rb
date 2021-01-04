require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerUserProject do
  describe '.call' do
    let(:ruby_lang)         { Language.find_by(name: 'ruby') }
    let!(:project)          { create(:project, language: ruby_lang) }
    let(:beginning_of_day)  { Time.zone.today.beginning_of_day }
    let(:entity_type)       { 'UsersProject' }
    let(:metric_name)       { :review_turnaround }
    let(:metrics_number)    { 1 }
    let(:user)              { create(:user) }
    let(:subject)           { described_class.call(user.id) }

    context 'when there is available data' do
      before do
        rr1 = create(:review_request, project: project, owner: user)
        rr2 = create(:review_request, project: project, owner: user)
        create(:completed_review_turnaround, review_request: rr1, value: 1.hour)
        create(:completed_review_turnaround, review_request: rr2, value: 3.hours)
        create(:users_project, project: project, user: user)
      end

      it_behaves_like 'available metrics data'
    end

    it_behaves_like 'unavailable metrics data'
  end
end
