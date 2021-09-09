# == Schema Information
#
# Table name: events_repositories
#
#  id            :bigint           not null, primary key
#  action        :string
#  deleted_at    :datetime
#  html_url      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  repository_id :bigint           not null
#  sender_id     :bigint           not null
#
# Indexes
#
#  index_events_repositories_on_repository_id  (repository_id)
#  index_events_repositories_on_sender_id      (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (sender_id => users.id)
#

FactoryBot.define do
  factory :event_repository, class: Events::Repository do
    action { Events::Repository.actions.values.sample }
    html_url { Faker::Internet.url(host: 'github.com') }
    association :repository
    association :sender, factory: :user
  end
end
