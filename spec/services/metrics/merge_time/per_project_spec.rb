require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerProject do
  describe '.call' do
    let(:ruby_lang)         { Language.find_by(name: 'ruby')  }
    let(:react_lang)        { Language.find_by(name: 'react') }
    let!(:first_project)    { create(:project, language: ruby_lang)  }
    let!(:second_project)   { create(:project, language: react_lang) }
    let(:projects)          { [first_project, second_project] }
    let(:beginning_of_day)  { Time.zone.today.beginning_of_day }
    let(:entity_type)       { 'Project' }
    let(:metric_name)       { :merge_time }
    let(:subject)           { described_class.call }

    context 'when there is available data' do
      before do
        projects.each do |project|
          pr1 = create(:pull_request, project: project, merged_at: beginning_of_day + 1.hour)
          pr2 = create(:pull_request, project: project, merged_at: beginning_of_day + 3.hours)
          create(:merge_time, pull_request: pr1, value: 1.hour.seconds)
          create(:merge_time, pull_request: pr2, value: 3.hours.seconds)
        end
      end

      it_behaves_like 'available metrics data'
    end

    it_behaves_like 'unavailable metrics data'
  end
end
