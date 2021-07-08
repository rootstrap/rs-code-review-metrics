# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
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
#  index_projects_on_language_id  (language_id)
#  index_projects_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

require 'rails_helper'

describe Project, type: :model do
  subject { build :project }

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
    let!(:private_project) do
      create(
        :project,
        is_private: true,
        language: language,
        relevance: Project.relevances[:internal]
      )
    end
    let!(:unassigned_project) do
      create(
        :project,
        is_private: false,
        language: Language.unassigned,
        relevance: Project.relevances[:internal]
      )
    end
    let!(:ignored_project) do
      create(
        :project,
        is_private: false,
        language: language,
        relevance: Project.relevances[:ignored]
      )
    end
    let!(:open_source_project) do
      create(
        :project,
        is_private: false,
        language: language,
        relevance: Project.relevances[:internal]
      )
    end

    it 'returns the projects that have an assigned language and are not private' do
      expect(Project.open_source).to contain_exactly(open_source_project)
    end
  end

  describe '#with_language' do
    let(:language) { Language.find_by(name: 'ruby') }
    let!(:project_with_language) { create(:project, language: language) }
    let!(:project_without_language) { create(:project, language: Language.unassigned) }

    it 'returns the projects that have an assigned language' do
      expect(Project.with_language).to contain_exactly(project_with_language)
    end
  end

  describe '#internal' do
    let!(:commercial_project) { create(:project, relevance: Project.relevances[:commercial]) }
    let!(:internal_project) { create(:project, relevance: Project.relevances[:internal]) }
    let!(:unassigned_project) { create(:project, relevance: Project.relevances[:unassigned]) }

    it 'returns only the internal projects' do
      expect(Project.internal).to contain_exactly(internal_project)
    end
  end

  describe '#relevant' do
    let!(:commercial_project) { create(:project, relevance: Project.relevances[:commercial]) }
    let!(:internal_project) { create(:project, relevance: Project.relevances[:internal]) }
    let!(:ignored_project) { create(:project, relevance: Project.relevances[:ignored]) }
    let!(:unassigned_project) { create(:project, relevance: Project.relevances[:unassigned]) }

    it 'returns both commecial and internal projects' do
      expect(Project.relevant).to contain_exactly(commercial_project, internal_project)
    end
  end

  describe '#with_activity_after' do
    let(:date) { 4.weeks.ago }
    let!(:updated_project) { create(:project) }
    let!(:not_updated_project) { create(:project) }

    context 'when a project has a pull request opened after the given date' do
      let!(:pull_request) do
        create(:pull_request, project: updated_project, opened_at: 2.weeks.ago)
      end

      it 'returns only that project' do
        expect(Project.with_activity_after(date)).to contain_exactly(updated_project)
      end
    end

    context 'when a project has a pull request merged after the given date' do
      let!(:pull_request) do
        create(
          :pull_request,
          project: updated_project,
          opened_at: 6.weeks.ago,
          merged_at: 2.weeks.ago
        )
      end

      it 'returns only that project' do
        expect(Project.with_activity_after(date)).to contain_exactly(updated_project)
      end
    end
  end

  describe '#full_name' do
    let(:org_name) { 'superiorg' }

    before { stub_env('GITHUB_ORGANIZATION', org_name) }

    it 'returns the full name of the project' do
      expect(subject.full_name).to eq("#{org_name}/#{subject.name}")
    end
  end
end
