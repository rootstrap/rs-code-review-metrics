require 'rails_helper'

RSpec.describe Builders::PullRequestSize do
  describe '.call' do
    let(:pull_request) { create(:pull_request) }
    let(:total_additions) { 500 }
    let(:pull_request_file_payloads) do
      [create(:pull_request_file_payload, additions: total_additions)]
    end

    before { stub_pull_request_files_with_pr(pull_request, pull_request_file_payloads) }

    context 'when there is no pull request size created' do
      it 'creates a new one' do
        expect { described_class.call(pull_request) }
          .to change { PullRequestSize.count }
          .by(1)
      end

      it 'assigns the correct value to it' do
        expect(described_class.call(pull_request).value).to eq total_additions
      end
    end

    context 'when there is already a pull request size created' do
      let(:previous_value) { total_additions }
      let!(:pull_request_size) do
        create(:pull_request_size, pull_request: pull_request, value: previous_value)
      end

      it 'does not create a new one' do
        expect { described_class.call(pull_request) }
          .not_to change { PullRequestSize.count }
      end

      it 'returns it' do
        expect(described_class.call(pull_request)).to eq pull_request_size
      end

      context 'and has an outdated value' do
        let(:previous_value) { 1 }

        it 'updates it' do
          expect(described_class.call(pull_request).value).to eq total_additions
        end
      end
    end
  end
end
