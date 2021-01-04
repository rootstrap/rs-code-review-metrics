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
