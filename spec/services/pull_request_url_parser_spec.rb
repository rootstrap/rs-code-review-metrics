require 'rails_helper'

RSpec.describe PullRequestUrlParser do
  let(:project_full_name) { 'rootstrap/rs-code-review-metrics' }
  let(:pull_request_number) { 111 }
  let(:url) { "https://github.com/#{project_full_name}/pull/#{pull_request_number}" }
  let(:parser) { described_class.call(url) }

  describe '#project_full_name' do
    it 'returns the full name of the project' do
      expect(parser.project_full_name).to eq project_full_name
    end
  end

  describe '#pull_request_number' do
    it 'returns the number of the pull request' do
      expect(parser.pull_request_number).to eq pull_request_number
    end
  end
end
