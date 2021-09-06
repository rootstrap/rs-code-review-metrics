# == Schema Information
#
# Table name: code_owner_projects
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
#  index_code_owner_projects_on_repository_id  (repository_id)
#  index_code_owner_projects_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe CodeOwnerProject, type: :model do
  it { is_expected.to belong_to(:repository) }
  it { is_expected.to belong_to(:user) }
end
