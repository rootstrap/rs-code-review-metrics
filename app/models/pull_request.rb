# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  state      :string           not null
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#

class PullRequest < ApplicationRecord
  has_many :review_requests, dependent: :destroy, inverse_of: :pull_request
  validates :github_id,
            :state,
            :node_id,
            :title,
            :number,
            :draft,
            :merged,
            :locked,
            presence: true
end
