# == Schema Information
#
# Table name: events_review_comments
#
#  id              :bigint           not null, primary key
#  body            :string
#  state           :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :bigint
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_events_review_comments_on_owner_id         (owner_id)
#  index_events_review_comments_on_pull_request_id  (pull_request_id)
#  index_events_review_comments_on_state            (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#

FactoryBot.define do
  sequence(:review_comment_id, 100)

  factory :review_comment, class: Events::ReviewComment do
    github_id { generate(:review_comment_id) }
    body

    association :pull_request
    association :owner, factory: :user
  end
end
