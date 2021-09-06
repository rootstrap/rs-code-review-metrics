# == Schema Information
#
# Table name: events_pushes
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
#  index_events_pushes_on_project_id       (project_id)
#  index_events_pushes_on_pull_request_id  (pull_request_id)
#  index_events_pushes_on_sender_id        (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
#  fk_rails_...  (sender_id => users.id)
#

module Events
  class Push < ApplicationRecord
    acts_as_paranoid

    belongs_to :project
    belongs_to :pull_request, class_name: 'Events::PullRequest', optional: true
    belongs_to :sender, class_name: 'User', foreign_key: :sender_id, inverse_of: :pushes
    has_one :event, as: :handleable, dependent: :destroy
  end
end
