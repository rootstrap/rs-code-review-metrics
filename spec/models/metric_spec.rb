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
    it { should validate_presence_of(:entity_key)  }
    it { should validate_length_of(:entity_key) .is_at_most(255) }

    describe 'of metric_key' do
      it 'fails with a missing value' do
        subject.metric_key = nil

        expect(subject).to_not be_valid
      end

      it 'fails with a value too long' do
        subject.metric_key = 'a' * 256

        expect(subject).to_not be_valid
      end
    end

    describe 'of the metric value' do
      it 'does not fail with a missing value since the metric could have not been run yet' do
        subject.value = nil

        expect(subject).to be_valid
      end
    end

    describe 'of the metric value_timestamp' do
      it 'does not fail with a missing timestamp since the metric could have not been run yet' do
        subject.value_timestamp = nil

        expect(subject).to be_valid
      end
    end
  end
end
