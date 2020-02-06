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

  validates :lang, inclusion: { in: langs.keys }
  validates :github_id, presence: true, uniqueness: true

  class << self
    def resolve(payload)
      handle_event(payload)
    end

    private

    def handle_event(payload)
      repo = payload['repository']
      project = find_or_create_by!(github_id: repo['id']) do |pj|
        pj.name = repo['name']
        pj.description = repo['description']
      end

      Event.new(project: project, data: payload, name: payload['event'])
           .resolve
    end
  end
end
