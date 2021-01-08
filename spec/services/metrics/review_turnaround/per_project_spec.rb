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
        review_request1 = create(:review_request, project: project)
        review_request2 = create(:review_request, project: project)
        create(:completed_review_turnaround, review_request: review_request1, value: 1.hour)
        create(:completed_review_turnaround, review_request: review_request2, value: 3.hours)
      end

      it_behaves_like 'available metrics data'

      context 'when interval is set' do
        let(:subject) { described_class.call(project.id, interval) }

        before do
          review_request = create(:review_request, project: project)
          create(:completed_review_turnaround, review_request: review_request,
                                               value: 1.hour, created_at: 5.weeks.ago)
        end

        it_behaves_like 'metric value unchanged'
      end
    end

    it_behaves_like 'unavailable metrics data'
  end
end
