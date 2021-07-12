# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  description     :string
#  name            :string           not null
#  jira_project_id :bigint
#
# Indexes
#
#  index_products_on_jira_project_id  (jira_project_id)
#  index_products_on_name             (name)
#
# Foreign Keys
#
#  fk_rails_...  (jira_project_id => jira_projects.id)
#

class Product < ApplicationRecord
  belongs_to :jira_project

  has_many :projects, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :jira_project
end
