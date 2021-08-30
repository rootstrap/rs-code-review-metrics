# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  branch     :string
#  closed_at  :datetime
#  deleted_at :datetime
#  draft      :boolean          not null
#  html_url   :string
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  size       :integer
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#  owner_id   :bigint
#  project_id :bigint
#
# Indexes
#
#  index_pull_requests_on_github_id   (github_id) UNIQUE
#  index_pull_requests_on_owner_id    (owner_id)
#  index_pull_requests_on_project_id  (project_id)
#  index_pull_requests_on_state       (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (project_id => projects.id)
#
module Events
  class PullRequest < ApplicationRecord
    acts_as_paranoid

    enum state: { open: 'open', closed: 'closed' }

    belongs_to :project, inverse_of: :pull_requests
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

    after_validation :build_merge_time, on: :update, if: :merged_at_changed?

    private

    def build_merge_time
      Builders::MergeTime.call(self)
    end
  end
end
