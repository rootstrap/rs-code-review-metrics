# == Schema Information
#
# Table name: repositories
#
#  id         :bigint           not null, primary key
#  action     :string
#  html_url   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  sender_id  :bigint           not null
#
# Indexes
#
#  index_repositories_on_project_id  (project_id)
#  index_repositories_on_sender_id   (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (sender_id => users.id)
#

FactoryBot.define do
  factory :repository, class: Events::Repository do
    action { Events::Repository.actions.values.sample }
    html_url { Faker::Internet.url(host: 'github.com') }
    association :project
    association :sender, factory: :user
  end
end
