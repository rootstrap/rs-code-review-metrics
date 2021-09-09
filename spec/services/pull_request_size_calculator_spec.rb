require 'rails_helper'

RSpec.describe PullRequestSizeCalculator do
  describe '.call' do
    subject(:pull_request_size) { described_class.call(pull_request) }

    let(:repository) { create(:repository) }
    let(:pull_request) { create(:pull_request, repository: repository) }
    let(:pr_file_1) { create(:pull_request_file_payload) }
    let(:pr_file_2) { create(:pull_request_file_payload) }
    let(:pr_file_payloads) { [pr_file_1, pr_file_2] }
    let(:total_additions) { pr_file_1['additions'] + pr_file_2['additions'] }

    before { stub_pull_request_files_with_pr(pull_request, pr_file_payloads) }

    it 'returns the total sum of the additions of each file of the PR' do
      expect(pull_request_size).to eq(total_additions)
    end

    context 'when one of the files matches a file ignoring rule' do
      let(:filename) { 'spec/services/pull_request_size_calculator_spec.rb' }
      let(:pr_language) { pull_request.repository.language }
      let(:pr_file_2) { create(:pull_request_file_payload, filename: filename) }

      before { create(:file_ignoring_rule, regex: 'spec/', language: pr_language) }

      it 'does not count the additions of that file' do
        expect(pull_request_size).to eq(pr_file_1['additions'])
      end
    end
  end
end
