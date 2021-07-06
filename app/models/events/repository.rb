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

module Events
  class Repository < ApplicationRecord
    enum action: {
      created: 'created',
      deleted: 'deleted',
      archived: 'archived',
      unarchived: 'unarchived',
      edited: 'edited',
      renamed: 'renamed',
      transferred: 'transferred',
      publicized: 'publicized',
      privatized: 'privatized'
    }

    belongs_to :project
    has_one :event, as: :handleable, dependent: :destroy
    belongs_to :sender, class_name: 'User', foreign_key: :sender_id, inverse_of: :repositories
  end
end
