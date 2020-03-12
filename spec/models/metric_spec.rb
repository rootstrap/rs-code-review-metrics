# == Schema Information
#
# Table name: metrics
#
#  id                    :bigint           not null, primary key
#  entity_key            :string           not null
#  metric_key            :string           not null
#  value                 :decimal(, )
#  value_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  metrics_definition_id :bigint           not null
#
# Indexes
#
#  index_metrics_on_metrics_definition_id  (metrics_definition_id)
#
# Foreign Keys
#
#  fk_rails_...  (metrics_definition_id => metrics_definitions.id)
#

require 'rails_helper'

RSpec.describe Metric, type: :model do
  subject { build :metric }

  describe 'database schema' do
    it 'has an entity_key field' do
      expect(subject).to have_db_column(:entity_key)
        .of_type(:string)
        .with_options(null: false)
    end

    it 'has an metric_key field' do
      expect(subject).to have_db_column(:metric_key)
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
  end

  describe 'validations' do
    it { should validate_presence_of(:entity_key) }
    it { should validate_length_of(:entity_key) .is_at_most(255) }

    it { should validate_presence_of(:metric_key) }
    it { should validate_length_of(:metric_key) .is_at_most(255) }

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
