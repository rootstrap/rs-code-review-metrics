# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#  index_pull_requests_on_state      (state)
#
module Events
  class PullRequest < ApplicationRecord
    enum state: { opened: 'opened', closed: 'closed' }

    has_many :review_requests, dependent: :destroy, inverse_of: :pull_request
    has_many :review_comments, class_name: 'Events::ReviewComment',
                               dependent: :destroy, inverse_of: :pull_request
    has_many :reviews, class_name: 'Events::Review', dependent: :destroy,
                       inverse_of: :pull_request
    has_many :events, as: :handleable, dependent: :destroy

    validates :state, inclusion: { in: states.keys }
    validates :github_id,
              :state,
              :node_id,
              :title,
              :number,
              presence: true
    validates :draft,
              :locked,
              inclusion: { in: [true, false] }
    validates :github_id, uniqueness: true
  end
end
