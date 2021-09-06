# == Schema Information
#
# Table name: repositories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  is_private  :boolean
#  name        :string
#  relevance   :enum             default("unassigned"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#  language_id :bigint
#  product_id  :bigint
#
# Indexes
#
#  index_repositories_on_language_id  (language_id)
#  index_repositories_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

require 'rails_helper'

describe Repository, type: :model do
  subject { build :repository }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.github_id = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:github_id) }
    it { is_expected.to have_many(:events) }
  end

  describe '#open_source' do
    let(:language) { Language.find_by(name: 'ruby') }
    let!(:private_repository) do
      create(
        :repository,
        is_private: true,
        language: language,
        relevance: Repository.relevances[:internal]
      )
    end
    let!(:unassigned_repository) do
      create(
        :repository,
        is_private: false,
        language: Language.unassigned,
        relevance: Repository.relevances[:internal]
      )
    end
    let!(:ignored_repository) do
      create(
        :repository,
        is_private: false,
        language: language,
        relevance: Repository.relevances[:ignored]
      )
    end
    let!(:open_source_repository) do
      create(
        :repository,
        is_private: false,
        language: language,
        relevance: Repository.relevances[:internal]
      )
    end

    it 'returns the repositories that have an assigned language and are not private' do
      expect(Repository.open_source).to contain_exactly(open_source_repository)
    end
  end

  describe '#with_language' do
    let(:language) { Language.find_by(name: 'ruby') }
    let!(:repository_with_language) { create(:repository, language: language) }
    let!(:repository_without_language) { create(:repository, language: Language.unassigned) }

    it 'returns the repositories that have an assigned language' do
      expect(Repository.with_language).to contain_exactly(repository_with_language)
    end
  end

  describe '#internal' do
    let!(:commercial_repository) do
      create(:repository, relevance: Repository.relevances[:commercial])
    end
    let!(:internal_repository) do
      create(:repository, relevance: Repository.relevances[:internal])
    end
    let!(:unassigned_repository) do
      create(:repository, relevance: Repository.relevances[:unassigned])
    end

    it 'returns only the internal repositories' do
      expect(Repository.internal).to contain_exactly(internal_repository)
    end
  end

  describe '#relevant' do
    let!(:commercial_repository) do
      create(:repository, relevance: Repository.relevances[:commercial])
    end
    let!(:internal_repository) do
      create(:repository, relevance: Repository.relevances[:internal])
    end
    let!(:ignored_repository) do
      create(:repository, relevance: Repository.relevances[:ignored])
    end
    let!(:unassigned_repository) do
      create(:repository, relevance: Repository.relevances[:unassigned])
    end

    it 'returns both commecial and internal repositories' do
      expect(Repository.relevant).to contain_exactly(commercial_repository, internal_repository)
    end
  end

  describe '#with_activity_after' do
    let(:date) { 4.weeks.ago }
    let!(:updated_repository) { create(:repository) }
    let!(:not_updated_repository) { create(:repository) }

    context 'when a repository has a pull request opened after the given date' do
      let!(:pull_request) do
        create(:pull_request, repository: updated_repository, opened_at: 2.weeks.ago)
      end

      it 'returns only that repository' do
        expect(Repository.with_activity_after(date)).to contain_exactly(updated_repository)
      end
    end

    context 'when a repository has a pull request merged after the given date' do
      let!(:pull_request) do
        create(
          :pull_request,
          repository: updated_repository,
          opened_at: 6.weeks.ago,
          merged_at: 2.weeks.ago
        )
      end

      it 'returns only that repository' do
        expect(Repository.with_activity_after(date)).to contain_exactly(updated_repository)
      end
    end
  end

  describe '#full_name' do
    let(:org_name) { 'superiorg' }

    before { stub_env('GITHUB_ORGANIZATION', org_name) }

    it 'returns the full name of the repository' do
      expect(subject.full_name).to eq("#{org_name}/#{subject.name}")
    end
  end
end
