# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  description   :string
#  lang          :enum             default("unassigned")
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint
#  github_id     :integer          not null
#
# Indexes
#
#  index_projects_on_department_id  (department_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#

class Project < ApplicationRecord
  enum lang: { ruby: 'ruby', python: 'python', nodejs: 'nodejs',
               ios: 'ios', android: 'android', reactnative: 'react_native',
               react: 'react', vuejs: 'vuejs',
               others: 'others', unassigned: 'unassigned' }

  belongs_to :department, optional: true
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

  before_save :associate_department

  private

  DEPARTMENT_LANGS = {
    backend: %w[ruby python nodejs].freeze,
    frontend: %w[react vuejs].freeze,
    mobile: %w[ios android react_native].freeze
  }.freeze

  def associate_department
    if self.department.nil? || self.lang_changed?
      department_name = DEPARTMENT_LANGS.select { |_key, values| values.include?(lang) }.keys.first
      self.department = Department.find_or_create_by!(name: department_name) unless department_name.nil?
    end
  end
end
