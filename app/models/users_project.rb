# == Schema Information
#
# Table name: users_projects
#
#  id            :bigint           not null, primary key
#  deleted_at    :datetime
#  repository_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_users_projects_on_repository_id  (repository_id)
#  index_users_projects_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#

class UsersProject < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :repository
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :repository_id }

  delegate :name, to: :user, prefix: true
end
