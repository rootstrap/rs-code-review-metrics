# == Schema Information
#
# Table name: review_comments
#
#  id              :bigint           not null, primary key
#  body            :string
#  status          :enum             default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_review_comments_on_owner_id         (owner_id)
#  index_review_comments_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

FactoryBot.define do
  factory :review_comment, class: Events::ReviewComment do
    github_id { Faker::Number.unique.number(digits: 4) }
    body { Faker::Quote.matz }

    association :pull_request, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
