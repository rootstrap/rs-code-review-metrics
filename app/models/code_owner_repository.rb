# == Schema Information
#
# Table name: code_owner_repositories
#
#  id            :bigint           not null, primary key
#  deleted_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  repository_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_code_owner_repositories_on_repository_id  (repository_id)
#  index_code_owner_repositories_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (user_id => users.id)
#

class CodeOwnerRepository < ApplicationRecord
  acts_as_paranoid

  belongs_to :repository
  belongs_to :user

  RANSACK_ATTRIBUTES = %w[created_at deleted_at id id_value repository_id updated_at user_id].freeze
end
