# == Schema Information
#
# Table name: pull_request_comments
#
#  id                :bigint           not null, primary key
#  body              :string
#  deleted_at        :datetime
#  opened_at         :datetime         not null
#  state             :enum             default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  pull_request_id   :bigint           not null
#  review_request_id :bigint
#
# Indexes
#
#  index_pull_request_comments_on_deleted_at         (deleted_at)
#  index_pull_request_comments_on_owner_id           (owner_id)
#  index_pull_request_comments_on_pull_request_id    (pull_request_id)
#  index_pull_request_comments_on_review_request_id  (review_request_id)
#  index_pull_request_comments_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

require 'rails_helper'

describe Events::PullRequestComment, type: :model do
  describe 'validations' do
    subject { build :pull_request_comment }

    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:review_request) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.github_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without body' do
      subject.body = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without opened_at' do
      subject = build :pull_request_comment, opened_at: nil
      expect(subject).to_not be_valid
    end
  end

  describe 'callbacks' do
    describe '#build_review_or_comment_turnaround' do
      context 'when a pull request comment is created' do
        let(:pull_request) { create(:pull_request) }
        let(:review_request) { create(:review_request, pull_request: pull_request) }
        let(:pull_request_comment) do
          create :pull_request_comment, review_request: review_request
        end

        before { travel_to(Time.zone.today.beginning_of_day) }

        it 'calls the review/comment builder helper' do
          expect(Builders::ReviewOrCommentTurnaround). to receive(:call)
          pull_request_comment
        end
      end
    end
  end
end
