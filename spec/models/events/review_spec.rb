# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  body            :string
#  status          :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_owner_id         (owner_id)
#  index_reviews_on_pull_request_id  (pull_request_id)
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

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.github_id = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to belong_to(:pull_request) }
  end

  describe 'actions' do
    subject { create :review, payload: payload }

    let(:payload) do
      {
        action: 'created',
        review: {
          pull_request_review_id: 237_895_671,
          id: 284_312_630,
          user: {
            login: 'Codertocat',
            id: 21_031_067,
            node_id: 'MDQ6VXNlcjIxMDMxMDY3'
          },
          body: 'You might need to fix this.'
        },
        pull_request: {
          id: 279_147_437
        },
        changes: {
          body: 'Please fix this.'
        }
      }.deep_stringify_keys
    end

    describe '#find_or_create_review' do
      subject { build :review }
      before { create :pull_request, github_id: payload['pull_request']['id'] }

      it 'creates a review' do
        expect {
          subject.send(:find_or_create_review, payload)
        }.to change(described_class, :count).by(1)
      end

      it 'finds a pull request' do
        subject.github_id = payload['review']['id']
        subject.save!

        expect(subject.send(:find_or_create_review, payload)).to eq(subject)
      end
    end

    describe '#submitted' do
      before { subject.payload['action'] = 'submitted' }

      it 'sets body' do
        expect {
          subject.resolve
        }.to change { subject.reload.body }.from(nil).to(payload['review']['body'])
      end
    end

    describe '#edited' do
      before { subject.payload['action'] = 'edited' }

      it 'edits body' do
        body = payload['review']['body']
        subject.update!(body: body)
        expect {
          subject.resolve
        }.to change { subject.reload.body }.from(body).to(payload['changes']['body'])
      end
    end

    describe '#dismissed' do
      before { subject.payload['action'] = 'dismissed' }

      it 'sets removed' do
        expect {
          subject.resolve
        }.to change { subject.reload.status }.from('active').to('removed')
      end
    end
  end
end

