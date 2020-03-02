# == Schema Information
#
# Table name: metrics_definitions
#
#  id                :bigint           not null, primary key
#  metrics_name      :string           not null
#  metrics_processor :string           not null
#  subject           :string           not null
#  time_interval     :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
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
end
