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

FactoryBot.define do
  factory :review_coverage do
    total_files_changed { Faker::Number.between(from: 1, to: 100) }
    files_with_comments_count { Faker::Number.between(from: 0, to: total_files_changed) }
    pull_request
  end
end
