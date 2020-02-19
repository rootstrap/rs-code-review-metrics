# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  lang        :enum             default("unassigned")
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
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

  context '#resolve' do
    let(:repository_payload) { build :repository_payload, name: 'rs-code-review-metrics', id: 1 }
    let(:payload) { build :repository_event_payload, repository: repository_payload }

    it 'creates a project' do
      allow_any_instance_of(Event).to receive(:resolve)

      expect {
        described_class.resolve(payload)
      }.to change(described_class, :count).by(1)
    end
  end
end
