require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerDepartment do
  describe '.call' do
    let(:ruby_lang)       { Language.find_by(name: 'ruby')  }
    let(:react_lang)      { Language.find_by(name: 'react') }
    let!(:first_project)  { create(:project, language: ruby_lang)  }
    let!(:second_project) { create(:project, language: react_lang) }
    let(:projects)        { [first_project, second_project] }
    let(:entity_type)     { 'Department' }
    let(:metric_name)     { :review_turnaround }
    let(:subject)         { described_class.call }

    context 'when there is available data' do
      before do
        projects.each do |project|
          rr1 = create(:review_request, project: project)
          rr2 = create(:review_request, project: project)
          create(:completed_review_turnaround, review_request: rr1, value: 1.hour)
          create(:completed_review_turnaround, review_request: rr2, value: 3.hours)
        end
      end

      it_behaves_like 'available metrics data'
    end

    it_behaves_like 'unavailable metrics data'
  end
end
