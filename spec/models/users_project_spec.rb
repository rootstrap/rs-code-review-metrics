# == Schema Information
#
# Table name: users_projects
#
#  id         :bigint           not null, primary key
#  project_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_users_projects_on_project_id  (project_id)
#  index_users_projects_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe UsersProject, type: :model do
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:project_id) }
end
