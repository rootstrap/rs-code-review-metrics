require 'rails_helper'

RSpec.describe Builders::Chartkick::ProjectDistributionData do
  describe '.call' do
    context 'for a given entity' do
      it_behaves_like 'merge time data distribution'
      let(:range) do
        Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
      end

      let(:department) { Department.first }
      let(:project) { create :project, language: department.languages.first }
      let(:entity_id) { project.id }
      let(:values) { [2, 13, 25, 37, 49, 61, 73] }

      let(:query) do
        { value_timestamp: range }
      end

      subject do
        described_class.call(entity_id, query)
      end
    end
  end
end
