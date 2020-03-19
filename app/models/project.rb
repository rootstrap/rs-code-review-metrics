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

  validates :lang, inclusion: { in: langs.keys }
  validates :github_id, presence: true, uniqueness: true
end
