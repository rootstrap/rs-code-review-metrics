# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  login      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_users_on_github_id  (github_id) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  it 'has a valid factory' do
    expect(@user.valid?).to eq(true)
  end

  it 'does not allow empty data' do
    @user.node_id = nil
    @user.github_id = nil
    @user.login = nil
    expect(@user.valid?).to eq(false)
  end

  it 'has a unique github_id' do
    create(:user, github_id: '0001')
    duplicate = build(:user, github_id: '0001')
    expect(duplicate.valid?).to eq(false)
  end
end
