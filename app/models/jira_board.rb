# == Schema Information
#
# Table name: jira_boards
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  jira_project_key :string           not null
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint
#
# Indexes
#
#  index_jira_boards_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

class JiraBoard < ApplicationRecord
  acts_as_paranoid

  belongs_to :product

  has_many :jira_issues, dependent: :destroy

  validates :jira_project_key, presence: true, uniqueness: true, allow_blank: true
end