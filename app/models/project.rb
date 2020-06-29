# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  is_private  :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#  language_id :bigint
#
# Indexes
#
#  index_projects_on_language_id  (language_id)
#

class Project < ApplicationRecord
  belongs_to :language

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

  has_many :code_owner_projects, dependent: :destroy
  has_many :code_owners,
           through: :code_owner_projects,
           source: :user

  validates :github_id, presence: true, uniqueness: true

  before_validation :set_default_language, on: :create

  private

  def set_default_language
    return unless language.nil?

    self.language = Language.find_by(name: 'unassigned')
  end
end
