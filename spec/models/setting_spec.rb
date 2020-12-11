# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string           default("")
#  key         :string           not null
#  value       :string
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#

require 'rails_helper'

RSpec.describe Setting, type: :model do
  subject { build :setting }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key) }

  describe 'scopes' do
    describe 'success_rate' do
      let(:department_name) { 'backend' }
      let(:metric_name) { 'merge_time' }
      let!(:success_rate_setting) do
        create(:setting, key: Setting::SUCCESS_PREFIX + '_' + department_name + '_' + metric_name)
      end
      let!(:setting) { create(:setting) }

      it 'returns setting' do
        query = Setting.success_rate(department_name, metric_name)
        expect(query.first).to eq success_rate_setting
      end

      it 'returns matching settings only' do
        query = Setting.success_rate(department_name, metric_name)
        expect(query.count).to eq 1
      end
    end
  end
end
