require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerProject do
  describe '.call' do
    let(:ruby_lang)       { Language.find_by(name: 'ruby') }
    let!(:project)        { create(:project, language: ruby_lang) }
    let(:entity_type)     { 'Project' }
    let(:metric_name)     { :review_turnaround }
    let(:metrics_number)  { 1 }
    let(:subject)         { described_class.call(project.id) }

    context 'when there is available data' do
      before do
        rr1 = create(:review_request, project: project)
        rr2 = create(:review_request, project: project)
        create(:completed_review_turnaround, review_request: rr1, value: 1.hour)
        create(:completed_review_turnaround, review_request: rr2, value: 3.hours)
      end

      it_behaves_like 'available metrics data'
    end

    it_behaves_like 'unavailable metrics data'
  end
end
