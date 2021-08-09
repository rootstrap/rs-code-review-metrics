# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  description      :string
#  jira_project_key :string
#  name             :string           not null
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#  index_products_on_name        (name)
#

class Product < ApplicationRecord
  acts_as_paranoid

  has_many :jira_issues, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :jira_project_key, uniqueness: true

  accepts_nested_attributes_for :projects
end
