require 'rails_helper'

RSpec.describe PullRequestSizeCalculator do
  describe '.call' do
    subject(:pull_request_size) { described_class.call(pull_request) }

    let(:project) { create(:project) }
    let(:pull_request) { create(:pull_request, project: project) }
    let(:pr_file_1) { create(:pull_request_file_payload) }
    let(:pr_file_2) { create(:pull_request_file_payload) }
    let(:pr_file_payloads) { [pr_file_1, pr_file_2] }
    let(:total_additions) { pr_file_1['additions'] + pr_file_2['additions'] }

    before do
      stub_pull_request_files(project, pull_request, pr_file_payloads)
    end

    it 'returns the total sum of the additions of each file of the PR' do
      expect(pull_request_size).to eq(total_additions)
    end
  end
end
