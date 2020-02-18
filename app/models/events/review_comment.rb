# == Schema Information
#
# Table name: review_comments
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
#  index_review_comments_on_owner_id         (owner_id)
#  index_review_comments_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class ReviewComment < ApplicationRecord
    enum status: { active: 'active', removed: 'removed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_review_comments
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :review_requests

    validates :status, inclusion: { in: statuses.keys }
    validates :github_id, presence: true
  end
end
