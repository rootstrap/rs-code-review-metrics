# == Schema Information
#
# Table name: code_owner_projects
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_code_owner_projects_on_project_id  (project_id)
#  index_code_owner_projects_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe CodeOwnerProject, type: :model do
  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:user) }
end
