# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#  index_pull_requests_on_state      (state)
#

require 'rails_helper'

RSpec.describe Events::PullRequest, type: :model do
  context 'validations' do
    subject { build :pull_request }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.github_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without state' do
      subject.state = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without number' do
      subject.number = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without node id' do
      subject.node_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without locked' do
      subject.locked = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without draft' do
      subject.draft = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without opened_at' do
      subject.opened_at = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:github_id) }
    it { is_expected.to have_many(:events) }
  end
end
