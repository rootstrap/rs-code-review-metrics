# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
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
#

require 'rails_helper'

RSpec.describe Events::PullRequest, type: :model do
  let(:pr) { build :pull_request }
  context 'validation' do
    it 'does not allow empty github_id' do
      pr.github_id = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow empty title' do
      pr.title = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow empty state' do
      pr.state = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow empty number' do
      pr.number = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow empty node_id' do
      pr.node_id = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow locked to be null' do
      pr.locked = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow merged to be null' do
      pr.merged = nil
      expect(pr.valid?).to eq(false)
    end

    it 'does not allow draft to be null' do
      pr.draft = nil
      expect(pr.valid?).to eq(false)
    end

    it 'has a unique github_id' do
      create(:pull_request, github_id: '0001')
      duplicate = build(:pull_request, github_id: '0001')
      expect(duplicate.valid?).to eq(false)
    end
  end
end
