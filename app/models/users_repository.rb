# == Schema Information
#
# Table name: users_repositories
#
#  id            :bigint           not null, primary key
#  deleted_at    :datetime
#  repository_id :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_users_repositories_on_repository_id  (repository_id)
#  index_users_repositories_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#

class UsersRepository < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :repository
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :repository_id }

  delegate :name, to: :user, prefix: true

  RANSACK_ATTRIBUTES = %w[created_at deleted_at id id_value repository_id updated_at user_id].freeze
end
