require 'rails_helper'

RSpec.describe Processors::ReviewTurnaroundPullRequestBackfiller do
  describe '.call' do
    let(:ruby_lang) { Language.find_by(name: 'ruby') }
    let!(:repository) { create(:repository, language: ruby_lang) }
    let!(:review_request) { create(:review_request, repository: repository) }
    let(:review_turnaround) do
      build(:review_turnaround,
            review_request: review_request,
            pull_request: nil)
    end

    before { review_turnaround.save!(validate: false) }
    it 'updates pull_request foreign_key in the completed review turnaround records' do
      expect { described_class.call }.to change { review_turnaround.reload.pull_request_id }
        .from(nil)
        .to(review_turnaround.review_request.pull_request_id)
    end
  end
end
