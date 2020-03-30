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

class UsersProject < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
