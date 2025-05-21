# == Schema Information
#
# Table name: review_coverages
#
#  id                        :bigint           not null, primary key
#  coverage_percentage       :decimal(, )      not null
#  deleted_at                :datetime
#  files_with_comments_count :integer          not null
#  total_files_changed       :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  pull_request_id           :bigint           not null
#
# Indexes
#
#  index_review_coverages_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#

class ReviewCoverage < ApplicationRecord
  acts_as_paranoid

  belongs_to :pull_request, class_name: 'Events::PullRequest'

  validates :total_files_changed, :files_with_comments_count, presence: true
  validates :pull_request_id, uniqueness: true
  validates :total_files_changed, :files_with_comments_count,
            numericality: { greater_than_or_equal_to: 0 }
end
