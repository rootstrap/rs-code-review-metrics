require 'rails_helper'

RSpec.describe Processors::CompletedReviewTurnaroundPullRequestBackfiller do
  describe '.call' do

    let(:department)      { Department.find_by(name: 'backend') }
    let(:ruby_lang)       { Language.find_by(name: 'ruby') }
    let!(:repository) { create(:repository, language: ruby_lang) }

    before do
      review_request = create(:review_request, repository: repository)
      let(:completed_review_turnaround) { create(:completed_review_turnaround,
                                                 review_request: review_request,
                                                 pull_request: nil) }
    end

    it 'updates pull_request foreign_key in the completed review recors' do
      expect { described_class.call }.to change { completed_review_turnaround.reload.pull_request_id }
                                           .from(nil)
                                           .to(completed_review_turnaround.review_request.pull_request_id)
    end
  end
end