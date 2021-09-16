# == Schema Information
#
# Table name: events_pull_request_comments
#
#  id                :bigint           not null, primary key
#  body              :string
#  opened_at         :datetime         not null
#  state             :enum             default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  pull_request_id   :bigint           not null
#  review_request_id :bigint
#
# Indexes
#
#  index_events_pull_request_comments_on_owner_id           (owner_id)
#  index_events_pull_request_comments_on_pull_request_id    (pull_request_id)
#  index_events_pull_request_comments_on_review_request_id  (review_request_id)
#  index_events_pull_request_comments_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#

FactoryBot.define do
  sequence(:pull_request_comment_id, 100)

  factory :pull_request_comment, class: Events::PullRequestComment do
    github_id { generate(:pull_request_comment_id) }
    body
    state { 'created' }
    opened_at { Time.current }

    association :pull_request
    association :review_request
    association :owner, factory: :user
  end
end
