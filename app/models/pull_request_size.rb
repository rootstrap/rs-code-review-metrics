# == Schema Information
#
# Table name: pull_request_sizes
#
#  id              :bigint           not null, primary key
#  value           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_pull_request_sizes_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

class PullRequestSize < ApplicationRecord
  belongs_to :pull_request, class_name: 'Events::PullRequest'

  validates :value, presence: true
  validates :pull_request_id, uniqueness: true
end
