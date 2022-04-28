# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  enabled     :boolean          default(TRUE), not null
#  name        :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#  index_products_on_enabled     (enabled)
#  index_products_on_name        (name)
#

class Product < ApplicationRecord
  acts_as_paranoid
  scope :enabled, lambda {
    where(enabled: true)
  }
  has_one :jira_board, dependent: :destroy
  has_many :repositories, dependent: :destroy
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :enabled, presence: true
  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :jira_board
  accepts_nested_attributes_for :repositories
end
