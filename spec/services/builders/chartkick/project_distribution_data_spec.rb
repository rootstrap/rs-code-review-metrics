require 'rails_helper'

RSpec.describe Builders::Chartkick::ProjectDistributionData do
  describe '.call' do
    context 'for a given entity' do
      let(:range) do
        Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
      end

      let(:department) { Department.first }
      let(:project) { create(:project, language: department.languages.first) }
      let(:entity_id) { project.id }
      let(:values_in_seconds) { [108_00, 900_00, 144_000, 198_000, 226_800, 270_000] }

      let(:query) do
        { value_timestamp: range }
      end

      subject do
        described_class.call(entity_id, query)
      end

      it_behaves_like 'merge time data distribution'
    end
  end
end
