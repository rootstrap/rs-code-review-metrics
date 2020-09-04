require 'rails_helper'

RSpec.describe Builders::ExternalProject do
  context 'when there is already a external project' do
    let!(:external_project) { create(:external_project) }

    let(:repository_data) do
      {
        id: external_project.github_id,
        name: external_project.name,
        full_name: external_project.full_name,
        description: external_project.description
      }
    end

    it 'returns that project' do
      expect(described_class.call(repository_data).github_id).to eq(repository_data[:id])
    end
  end

  context 'when there is no external project' do
    let(:repository_data) do
      {
        id: 247_546_341,
        name: 'ruby_repo',
        full_name: 'github/ruby_repo',
        description: 'this is a uby repo'
      }
    end

    subject { described_class.call(repository_data) }

    it 'builds a new one' do
      expect(subject.new_record?).to be true
    end

    it 'initializes all attributes correctly' do
      expect(subject.github_id).to    eq(repository_data[:id])
      expect(subject.name).to         eq(repository_data[:name])
      expect(subject.full_name).to    eq(repository_data[:full_name])
      expect(subject.description).to  eq(repository_data[:description])
    end
  end
end
