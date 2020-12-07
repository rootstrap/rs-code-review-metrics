# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  is_private  :boolean
#  name        :string
#  relevance   :enum             default("unassigned"), not null
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
  enum relevance: {
    commercial: 'commercial',
    internal: 'internal',
    ignored: 'ignored',
    unassigned: 'unassigned'
  }

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

  has_one :code_climate_project_metric, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true
  validates :relevance, inclusion: { in: relevances.keys }

  before_validation :set_default_language, on: :create

  scope :open_source, lambda {
    internal.with_language.where(is_private: false)
  }

  scope :with_language, lambda {
    joins(:language).where.not(languages: { name: 'unassigned' })
  }

  scope :internal, lambda {
    where(relevance: relevances[:internal])
  }

  scope :relevant, lambda {
    where(relevance: [relevances[:commercial], relevances[:internal]])
  }

  scope :with_activity_after, lambda { |date|
    with_a_pr_merged_after(date).or(with_a_pr_opened_after(date))
  }

  scope :with_a_pr_opened_after, lambda { |date|
    joins(:pull_requests).where('pull_requests.opened_at > ?', date)
  }

  scope :with_a_pr_merged_after, lambda { |date|
    joins(:pull_requests).where('pull_requests.merged_at > ?', date)
  }

  scope :by_department, lambda { |department|
    joins(language: :department).where(departments: { id: department.id })
  }

  scope :by_language, lambda { |languages|
    joins(:language).where(languages: { name: languages })
  }

  scope :without_cc, lambda {
    left_joins(:code_climate_project_metric).where(code_climate_project_metrics: { id: nil })
  }

  scope :without_cc_rate, lambda {
    left_joins(:code_climate_project_metric)
      .where(code_climate_project_metrics: { code_climate_rate: nil })
  }

  scope :without_cc_or_cc_rate, lambda {
    without_cc.or(without_cc_rate)
  }

  def full_name
    "#{organization_name}/#{name}"
  end

  def organization_name
    ENV['GITHUB_ORGANIZATION']
  end

  private

  def set_default_language
    return unless language.nil?

    self.language = Language.unassigned
  end
end
