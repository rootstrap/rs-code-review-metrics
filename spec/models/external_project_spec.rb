# == Schema Information
#
# Table name: external_projects
#
#  id          :bigint           not null, primary key
#  description :string
#  enabled     :boolean          default(TRUE), not null
#  full_name   :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :bigint           not null
#  language_id :bigint
#
# Indexes
#
#  index_external_projects_on_language_id  (language_id)
#

require 'rails_helper'

RSpec.describe ExternalProject, type: :model do
  subject { build :external_project }

  it { is_expected.to validate_uniqueness_of(:github_id) }
  it { is_expected.to validate_presence_of(:github_id) }

  context 'when is built with any language associated' do
    it 'establish unassign language as association' do
      subject.save!
      expect(subject.reload.language.name).to eq('unassigned')
    end
  end
end
