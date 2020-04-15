# == Schema Information
#
# Table name: metrics
#
#  id                    :bigint           not null, primary key
#  interval              :enum
#  name                  :enum
#  ownable_type          :string           not null
#  value                 :decimal(, )
#  value_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  metrics_definition_id :bigint           not null
#  ownable_id            :bigint           not null
#
# Indexes
#
#  index_metrics_on_metrics_definition_id        (metrics_definition_id)
#  index_metrics_on_ownable_type_and_ownable_id  (ownable_type,ownable_id)
#
# Foreign Keys
#
#  fk_rails_...  (metrics_definition_id => metrics_definitions.id)
#

require 'rails_helper'

RSpec.describe Metric, type: :model do
  subject { build :metric }

  describe 'database schema' do
    it 'has a ownable_id field' do
      expect(subject).to have_db_column(:ownable_id)
        .of_type(:integer)
        .with_options(null: false)
    end

    it 'has a ownable_type field' do
      expect(subject).to have_db_column(:ownable_type)
        .of_type(:string)
        .with_options(null: false)
    end

    it 'has a value field' do
      expect(subject).to have_db_column(:value)
        .of_type(:decimal)
        .with_options(null: true)
    end

    it 'has a value_timestamp field' do
      expect(subject).to have_db_column(:value_timestamp)
        .of_type(:datetime)
        .with_options(null: true)
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without interval' do
      subject.interval = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'validations' do
    describe 'does not fail with a' do
      it 'missing Metric.value since the metric could have not been run yet' do
        subject = build :metric, value: nil

        expect(subject).to be_valid
      end

      it 'missing Metric.value_timestamp since the metric could have not been run yet' do
        subject = build :metric, value_timestamp: nil

        expect(subject).to be_valid
      end
    end
  end
end
