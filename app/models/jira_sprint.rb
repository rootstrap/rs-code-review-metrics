# == Schema Information
#
# Table name: jira_sprints
#
#  id               :bigint           not null, primary key
#  active           :boolean
#  deleted_at       :datetime
#  ended_at         :datetime
#  name             :string
#  points_committed :integer
#  points_completed :integer
#  started_at       :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jira_board_id    :bigint           not null
#  jira_id          :integer          not null
#
# Indexes
#
#  index_jira_sprints_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

class JiraSprint < ApplicationRecord
  acts_as_paranoid

  belongs_to :jira_board

  validates :started_at, presence: true
  validates :jira_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { scope: :jira_board_id }
end
