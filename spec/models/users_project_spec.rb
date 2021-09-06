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

require 'rails_helper'

RSpec.describe UsersProject, type: :model do
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:repository_id) }
end
