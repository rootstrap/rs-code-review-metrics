# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  is_private  :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#  language_id :bigint
#
# Indexes
#
#  index_projects_on_language_id  (language_id)
#

require 'rails_helper'

RSpec.describe Project, type: :model do
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

  describe 'open_source' do
    let(:language) { Language.find_by(name: 'ruby') }
    let!(:private_project) { create(:project, is_private: true, language: language) }
    let!(:unassigned_project) { create(:project, language: Language.unassigned) }
    let!(:open_source_project) { create(:project, is_private: false, language: language) }

    it 'returns the projects that have an assigned language and are not private' do
      expect(Project.open_source).to contain_exactly(open_source_project)
    end
  end

  describe 'with_language' do
    let(:language) { Language.find_by(name: 'ruby') }
    let!(:project_with_language) { create(:project, language: language) }
    let!(:project_without_language) { create(:project, language: Language.unassigned) }

    it 'returns the projects that have an assigned language' do
      expect(Project.with_language).to contain_exactly(project_with_language)
    end
  end
end
