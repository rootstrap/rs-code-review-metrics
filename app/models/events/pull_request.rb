# == Schema Information
#
# Table name: events_pull_requests
#
#  id            :bigint           not null, primary key
#  body          :text
#  branch        :string
#  closed_at     :datetime
#  draft         :boolean          not null
#  html_url      :string
#  locked        :boolean          not null
#  merged_at     :datetime
#  number        :integer          not null
#  opened_at     :datetime
#  size          :integer
#  state         :enum
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  github_id     :bigint           not null
#  node_id       :string           not null
#  owner_id      :bigint
#  repository_id :bigint
#
# Indexes
#
#  index_events_pull_requests_on_github_id      (github_id) UNIQUE
#  index_events_pull_requests_on_owner_id       (owner_id)
#  index_events_pull_requests_on_repository_id  (repository_id)
#  index_events_pull_requests_on_state          (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#
module Events
  class PullRequest < ApplicationRecord
    enum state: { open: 'open', closed: 'closed' }

    belongs_to :repository, class_name: '::Repository', inverse_of: :pull_requests
    belongs_to :owner, class_name: 'User', foreign_key: :owner_id,
                       inverse_of: :created_pull_requests
    has_many :review_requests, dependent: :destroy, inverse_of: :pull_request
    has_many :review_comments, class_name: 'Events::ReviewComment',
                               dependent: :destroy, inverse_of: :pull_request
    has_many :reviews, class_name: 'Events::Review', dependent: :destroy,
                       inverse_of: :pull_request
    has_many :pushes, class_name: 'Events::Push', dependent: :destroy, inverse_of: :pull_request
    has_many :pull_request_comments, class_name: 'Events::PullRequestComment',
                                     dependent: :destroy, inverse_of: :pull_request
    has_many :events, as: :handleable, dependent: :destroy
    has_one :merge_time, dependent: :destroy
    has_one :review_coverage, dependent: :destroy

    validates :state, inclusion: { in: states.keys }
    validates :github_id,
              :state,
              :node_id,
              :title,
              :number,
              :opened_at,
              presence: true
    validates :draft,
              :locked,
              inclusion: { in: [true, false] }
    validates :github_id, uniqueness: true, strict: PullRequests::GithubUniquenessError
  end
end
