require 'rails_helper'

RSpec.describe Builders::ExternalProject do
  describe '.call' do
    subject { described_class.call(repository_data) }

    context 'when there is already a external project' do
      let!(:external_project) { create(:external_project) }
      let(:owner_name) { external_project.full_name.split('/').first }

      let(:repository_data) do
        build(
          :repository_payload,
          id: external_project.github_id,
          name: external_project.name,
          description: external_project.description,
          owner: { login: owner_name }
        ).deep_symbolize_keys
      end

      it 'returns that project' do
        expect(subject.github_id).to eq(repository_data[:id])
      end
    end

    context 'when there is no external project' do
      let(:repo_name) { 'ruby_repo' }
      let(:owner_name) { 'github' }
      let(:full_name) { "#{owner_name}/#{repo_name}" }
      let(:description) { 'some description' }

      let(:repository_data) do
        build(
          :repository_payload,
          name: repo_name,
          description: description,
          owner: { login: owner_name }
        ).deep_symbolize_keys
      end

      it 'creates a new one' do
        expect(subject.class).to eq(ExternalProject)
      end

      it 'initializes all attributes correctly' do
        expect(subject.github_id).to    eq(repository_data[:id])
        expect(subject.name).to         eq(repo_name)
        expect(subject.full_name).to    eq(full_name)
        expect(subject.description).to  eq(description)
      end
    end
  end
end
