# == Schema Information
#
# Table name: events_reviews
#
#  id                :bigint           not null, primary key
#  body              :string
#  deleted_at        :datetime
#  opened_at         :datetime         not null
#  state             :enum             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  project_id        :bigint
#  pull_request_id   :bigint           not null
#  review_request_id :bigint
#
# Indexes
#
#  index_events_reviews_on_owner_id           (owner_id)
#  index_events_reviews_on_project_id         (project_id)
#  index_events_reviews_on_pull_request_id    (pull_request_id)
#  index_events_reviews_on_review_request_id  (review_request_id)
#  index_events_reviews_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

require 'rails_helper'

RSpec.describe Events::Review, type: :model do
  describe 'validations' do
    subject { build :review }

    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:review_request) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject = build :review, github_id: nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without opened_at' do
      subject = build :review, opened_at: nil
      expect(subject).to_not be_valid
    end
  end

  describe 'callbacks' do
    describe '#build_review_or_comment_turnaround' do
      context 'when a review is created' do
        before { travel_to(Time.zone.today.beginning_of_day) }
        let(:review_request) { create(:review_request) }
        let(:review) { create :review, review_request: review_request }

        it 'calls the review/comment builder helper' do
          expect(Builders::ReviewOrCommentTurnaround).to receive(:call)
          review
        end
      end
    end
  end
end
