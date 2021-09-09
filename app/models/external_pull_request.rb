# == Schema Information
#
# Table name: external_pull_requests
#
#  id                     :bigint           not null, primary key
#  body                   :text
#  html_url               :string           not null
#  number                 :integer
#  opened_at              :datetime
#  state                  :enum
#  title                  :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  external_repository_id :bigint           not null
#  github_id              :bigint
#  owner_id               :bigint
#
# Indexes
#
#  index_external_pull_requests_on_external_repository_id  (external_repository_id)
#  index_external_pull_requests_on_owner_id                (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (external_repository_id => external_repositories.id)
#  fk_rails_...  (external_repository_id => external_repositories.id)
#  fk_rails_...  (owner_id => users.id)
#

class ExternalPullRequest < ApplicationRecord
  belongs_to :external_repository
  alias repository external_repository

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id,
                     inverse_of: :external_pull_requests

  enum state: { open: 'open', closed: 'closed', merged: 'merged' }
end
