require 'rails_helper'

RSpec.describe Builders::PullRequestSize do
  describe '.call' do
    let(:pull_request) { create(:pull_request, size: nil) }
    let(:total_additions) { 500 }
    let(:pull_request_file_payloads) do
      [create(:pull_request_file_payload, additions: total_additions)]
    end
    let(:subject) { described_class.call(pull_request) }

    before { stub_pull_request_files_with_pr(pull_request, pull_request_file_payloads) }

    it 'assigns the correct value to it' do
      subject
      expect(pull_request.size).to eq total_additions
    end

    context 'and has an outdated value' do
      let(:previous_value) { 1 }
      let(:pull_request) { create(:pull_request, size: previous_value) }

      it 'updates it' do
        expect { subject }.to change { pull_request.size }
          .from(previous_value)
          .to(total_additions)
      end
    end
  end
end
