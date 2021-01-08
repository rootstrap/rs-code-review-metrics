require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaround::PerLanguage do
  describe '.call' do
    let(:ruby_lang)       { Language.find_by(name: 'ruby') }
    let(:python_lang)     { Language.find_by(name: 'python') }
    let!(:first_project)  { create(:project, language: ruby_lang) }
    let!(:second_project) { create(:project, language: python_lang) }
    let(:projects)        { [first_project, second_project] }
    let(:entity_type)     { 'Language' }
    let(:metric_name)     { :review_turnaround }
    let(:metrics_number)  { 2 }
    let(:subject)         { described_class.call([ruby_lang.id, python_lang.id]) }

    context 'when there are two project metrics with different languages' do
      before do
        projects.each do |project|
          review_request1 = create(:review_request, project: project)
          review_request2 = create(:review_request, project: project)
          create(:completed_review_turnaround, review_request: review_request1, value: 1.hour)
          create(:completed_review_turnaround, review_request: review_request2, value: 3.hours)
        end
      end

      it_behaves_like 'available metrics data'

      context 'when interval is set' do
        let(:subject) { described_class.call([ruby_lang.id, python_lang.id], interval) }

        before do
          projects.each do |project|
            review_request = create(:review_request, project: project)
            create(:completed_review_turnaround, review_request: review_request,
                                                 value: 1.hour, created_at: 5.weeks.ago)
          end
        end

        it_behaves_like 'metric value unchanged'
      end
    end

    it_behaves_like 'unavailable metrics data'
  end
end
