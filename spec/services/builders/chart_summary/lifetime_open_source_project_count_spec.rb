require 'rails_helper'

describe Builders::ChartSummary::LifetimeOpenSourceProjectCount do
  describe '#call' do
    let(:language_1) { create(:language) }
    let(:language_2) { create(:language) }
    let(:project_count_1) { 9 }
    let(:project_count_2) { 6 }

    before do
      create_list(:project, project_count_1, :open_source, language: language_1)
      create_list(:project, project_count_2, :open_source, language: language_2)
    end

    it 'returns the total amount of projects per language' do
      projects_per_language = described_class.call
      expect(projects_per_language)
        .to match(a_hash_including(language_1.name => project_count_1))
      expect(projects_per_language)
        .to match(a_hash_including(language_2.name => project_count_2))
    end
  end
end
