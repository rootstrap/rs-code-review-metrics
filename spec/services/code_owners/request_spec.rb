require 'rails_helper'

RSpec.describe CodeOwners::Request do
  describe '.call' do
    let!(:project) { create(:project, name: 'rs-code-metrics') }
    context 'when project content from the github repo api' do
      context 'was not found or is empty' do
        before { stub_get_content_from_file_not_found }
        it 'does not call the code owner file handler' do
          expect_any_instance_of(CodeOwners::FileHandler).not_to receive(:call)
          described_class.call
        end
      end

      context 'is present' do
        before do
          stub_get_content_from_file_ok
          allow_any_instance_of(CodeOwners::ProjectHandler).to receive(:call)
        end

        it 'calls the code owner file handler' do
          expect_any_instance_of(CodeOwners::FileHandler).to receive(:call)
          described_class.call
        end

        it 'calls the code owner project handler' do
          expect_any_instance_of(CodeOwners::ProjectHandler).to receive(:call)
          described_class.call
        end
      end
    end
  end
end
