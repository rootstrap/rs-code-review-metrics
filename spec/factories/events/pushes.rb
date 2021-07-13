# == Schema Information
#
# Table name: pushes
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  ref             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  project_id      :bigint           not null
#  pull_request_id :bigint
#  sender_id       :bigint           not null
#
# Indexes
#
#  index_pushes_on_project_id       (project_id)
#  index_pushes_on_pull_request_id  (pull_request_id)
#  index_pushes_on_sender_id        (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#  fk_rails_...  (sender_id => users.id)
#

FactoryBot.define do
  factory :push, class: Events::Push do
    association :project
    association :sender, factory: :user
    ref { "refs/head/#{Faker::Company.bs.gsub(' ', '_').underscore}" }

    trait :with_pull_request do
      association :pull_request
    end
  end
end
