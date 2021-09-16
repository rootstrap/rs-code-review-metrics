# == Schema Information
#
# Table name: events_pushes
#
#  id              :bigint           not null, primary key
#  ref             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pull_request_id :bigint
#  repository_id   :bigint           not null
#  sender_id       :bigint           not null
#
# Indexes
#
#  index_events_pushes_on_pull_request_id  (pull_request_id)
#  index_events_pushes_on_repository_id    (repository_id)
#  index_events_pushes_on_sender_id        (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (sender_id => users.id)
#

FactoryBot.define do
  factory :push, class: Events::Push do
    association :repository
    association :sender, factory: :user
    ref { "refs/head/#{Faker::Company.bs.gsub(' ', '_').underscore}" }

    trait :with_pull_request do
      association :pull_request
    end
  end
end
