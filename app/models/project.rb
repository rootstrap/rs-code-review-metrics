# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  lang        :enum             default("unassigned")
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#

class Project < ApplicationRecord
  enum lang: { ruby: 'ruby', python: 'python', nodejs: 'nodejs',
               react: 'react', ios: 'ios', android: 'android',
               others: 'others', unassigned: 'unassigned' }

  has_many :events, dependent: :destroy
  has_many :pull_requests,
           class_name: 'Events::PullRequest',
           dependent: :destroy,
           inverse_of: :project
  has_many :reviews,
           class_name: 'Events::Review',
           dependent: :destroy,
           inverse_of: :project
  has_many :users_projects, dependent: :destroy
  has_many :users, through: :users_projects
  has_many :metrics, as: :ownable, dependent: :destroy

  validates :lang, inclusion: { in: langs.keys }
  validates :github_id, presence: true, uniqueness: true
end
