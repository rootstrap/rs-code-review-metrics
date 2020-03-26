# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  body            :string
#  opened_at       :datetime         not null
#  state           :enum             not null
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
#  index_reviews_on_state            (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class Review < ApplicationRecord
    enum state: { approved: 'approved',
                  commented: 'commented',
                  changes_requested: 'changes_requested',
                  dismissed: 'dismissed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_reviews
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :reviews

    validates :state, inclusion: { in: states.keys }
    validates :github_id, :opened_at, presence: true
  end
end
