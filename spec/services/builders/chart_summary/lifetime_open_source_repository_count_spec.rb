require 'rails_helper'

describe Builders::ChartSummary::LifetimeOpenSourceRepositoryCount do
  describe '#call' do
    let(:language_1) { create(:language) }
    let(:language_2) { create(:language) }
    let(:repository_count_1) { 9 }
    let(:repository_count_2) { 6 }

    before do
      create_list(:repository, repository_count_1, :open_source, language: language_1)
      create_list(:repository, repository_count_2, :open_source, language: language_2)
    end

    it 'returns the total amount of repositories per language' do
      repository_per_language = described_class.call
      expect(repository_per_language)
        .to match(a_hash_including(language_1.name => repository_count_1))
      expect(repository_per_language)
        .to match(a_hash_including(language_2.name => repository_count_2))
    end
  end
end
