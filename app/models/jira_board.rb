# == Schema Information
#
# Table name: jira_boards
#
#  id                :bigint           not null, primary key
#  deleted_at        :datetime
#  environment_field :string
#  jira_project_key  :string           not null
#  jira_self_url     :string
#  project_name      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  jira_board_id     :integer
#  product_id        :bigint
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
  has_many :jira_sprints, dependent: :destroy
  has_many :jira_environments, dependent: :destroy

  validates :jira_project_key, presence: true, uniqueness: true, allow_blank: true
  validates :jira_board_id, uniqueness: true, allow_blank: true
end
