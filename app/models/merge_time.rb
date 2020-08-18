# == Schema Information
#
# Table name: merge_times
#
#  id              :bigint           not null, primary key
#  value           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_merge_times_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

class MergeTime < ApplicationRecord
  include EntityTimeRepresentation

  belongs_to :pull_request, class_name: 'Events::PullRequest'

  validates :value, presence: true
  validates :pull_request_id, uniqueness: true
end
