# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string           not null
#
# Indexes
#
#  index_products_on_name  (name)
#

class Product < ApplicationRecord
  has_one :jira_board, dependent: :destroy

  has_many :projects, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :jira_board
  accepts_nested_attributes_for :projects
end
