# == Schema Information
#
# Table name: alerts
#
#  id             :bigint           not null, primary key
#  active         :boolean
#  emails         :string           default([]), not null, is an Array
#  frequency      :integer          not null
#  last_sent_date :datetime
#  metric_name    :string           not null
#  name           :string
#  threshold      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :bigint
#  repository_id  :bigint
#
# Indexes
#
#  index_alerts_on_department_id  (department_id)
#  index_alerts_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (repository_id => repositories.id)
#

require 'rails_helper'

describe Alert, type: :model do
  subject { build :alert }

  context 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(subject).to be_valid
      end

      it { is_expected.to validate_presence_of(:metric_name) }
      it { is_expected.to validate_presence_of(:frequency) }
      it { is_expected.to validate_presence_of(:threshold) }
      it { is_expected.to validate_presence_of(:emails) }

      it { is_expected.to belong_to(:repository).optional }
      it { is_expected.to belong_to(:department).optional }
    end

    context 'with invalid attributes' do
      it 'is not valid without name' do
        subject.metric_name = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid without frequency' do
        subject.frequency = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid without threshold' do
        subject.threshold = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid without emails' do
        subject.emails = nil
        expect(subject).not_to be_valid
      end

      describe 'without department nor repository' do
        it 'returns error message' do
          subject.department = nil
          subject.repository = nil

          subject.valid?

          expect(subject.errors[:department_or_repository_presence])
            .to include I18n.t('alerts.department_or_repository_presence')
        end
      end
    end
  end
end
