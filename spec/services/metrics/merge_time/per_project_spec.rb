require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerProject do
  describe '.call' do
    let(:ruby_lang)         { Language.find_by(name: 'ruby') }
    let!(:project)          { create(:project, language: ruby_lang) }
    let(:beginning_of_day)  { Time.zone.today.beginning_of_day }
    let(:entity_type)       { 'Project' }
    let(:metric_name)       { :merge_time }
    let(:metrics_number)    { 1 }
    let(:subject)           { described_class.call(project.id) }

    context 'when there is available data' do
      before do
        pull_request1 = create(:pull_request, project: project,
                                              merged_at: beginning_of_day + 1.hour)
        pull_request2 = create(:pull_request, project: project,
                                              merged_at: beginning_of_day + 3.hours)
        create(:merge_time, pull_request: pull_request1, value: 1.hour.seconds)
        create(:merge_time, pull_request: pull_request2, value: 3.hours.seconds)
      end

      it_behaves_like 'available metrics data'

      context 'when interval is set' do
        let(:subject) { described_class.call(project.id, interval) }

        before do
          pull_request = create(:pull_request, project: project, merged_at: 5.weeks.ago)
          create(:merge_time, pull_request: pull_request, value: 1.hour.seconds)
        end

        it_behaves_like 'metric value unchanged'
      end
    end

    it_behaves_like 'unavailable metrics data'
  end
end
