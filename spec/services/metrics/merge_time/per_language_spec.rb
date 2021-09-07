require 'rails_helper'

RSpec.describe Metrics::MergeTime::PerLanguage do
  describe '.call' do
    let(:ruby_lang)          { Language.find_by(name: 'ruby') }
    let(:python_lang)        { Language.find_by(name: 'python') }
    let!(:first_repository)  { create(:repository, language: ruby_lang) }
    let!(:second_repository) { create(:repository, language: python_lang) }
    let(:repositories)       { [first_repository, second_repository] }
    let(:beginning_of_day)   { Time.zone.today.beginning_of_day }
    let(:entity_type)        { 'Language' }
    let(:metric_name)        { :merge_time }
    let(:metrics_number)     { 2 }
    let(:subject)            { described_class.call([ruby_lang.id, python_lang.id]) }

    context 'when there is available data' do
      before do
        repositories.each do |repository|
          pull_request1 = create(:pull_request, repository: repository,
                                                merged_at: beginning_of_day + 1.hour)
          pull_request2 = create(:pull_request, repository: repository,
                                                merged_at: beginning_of_day + 3.hours)
          create(:merge_time, pull_request: pull_request1, value: 1.hour.seconds)
          create(:merge_time, pull_request: pull_request2, value: 3.hours.seconds)
        end
      end

      it_behaves_like 'available metrics data'

      context 'when interval is set' do
        let(:subject) { described_class.call([ruby_lang.id, python_lang.id], interval) }

        before do
          repositories.each do |repository|
            pull_request = create(:pull_request, repository: repository, merged_at: 5.weeks.ago)
            create(:merge_time, pull_request: pull_request, value: 1.hour.seconds)
          end
        end

        it_behaves_like 'metric value unchanged'
      end
    end

    it_behaves_like 'unavailable metrics data'
  end
end
