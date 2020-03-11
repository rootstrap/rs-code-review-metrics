# == Schema Information
#
# Table name: metrics_definitions
#
#  id                        :bigint           not null, primary key
#  last_processed_event_time :datetime
#  metrics_name              :string           not null
#  metrics_processor         :string           not null
#  subject                   :string           not null
#  time_interval             :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'rails_helper'

RSpec.describe MetricsDefinition, type: :model do
  describe 'database schema' do
    it 'has a name field' do
      expect(subject).to have_db_column(:metrics_name)
        .of_type(:string)
        .with_options(null: false)
    end

    it 'has a time_interval field' do
      expect(subject).to have_db_column(:time_interval)
        .of_type(:string)
        .with_options(null: false)
    end

    it 'has a subject field' do
      expect(subject).to have_db_column(:subject)
        .of_type(:string)
        .with_options(null: false)
    end

    it 'has a metrics_processor field' do
      expect(subject).to have_db_column(:metrics_processor)
        .of_type(:string)
        .with_options(null: false)
    end

    it 'has a last_processed_event_time field' do
      expect(subject).to have_db_column(:last_processed_event_time)
        .of_type(:datetime)
        .with_options(null: true)
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:metrics_name) }
    it { should validate_length_of(:metrics_name) .is_at_most(255) }

    it { should validate_presence_of(:time_interval) }
    it { should validate_inclusion_of(:time_interval) .in_array(%w[all_times daily weekly]) }

    it { should validate_presence_of(:subject) }
    it { should validate_inclusion_of(:subject) .in_array(%w[projects users users_per_project]) }

    it { should validate_presence_of(:metrics_processor) }
  end

  describe 'time period' do
    it 'is nil if time_interval is nil' do
      expect(subject.time_period).to be_nil
    end

    it 'is DailyInterval if time_interval is "daily"' do
      subject.time_interval = 'daily'

      expect(subject.time_period).to be_kind_of(TimeIntervals::DailyInterval)
    end

    it 'preserves its identity among different calls' do
      subject.time_interval = 'daily'

      expect(subject.time_period).to be(subject.time_period)
    end

    it 'raises an error if time_interval is not defined' do
      expect {
        subject.time_interval = 'invalid_time_interval'
        subject.time_period
      } .to raise_error(KeyError)
    end
  end
end
