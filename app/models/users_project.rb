# == Schema Information
#
# Table name: users_projects
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  project_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_users_projects_on_project_id  (project_id)
#  index_users_projects_on_user_id     (user_id)
#

class UsersProject < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :project
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :project_id }

  delegate :name, to: :user, prefix: true
end
