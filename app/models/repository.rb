# == Schema Information
#
# Table name: repositories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  description :string
#  is_private  :boolean
#  name        :string
#  relevance   :enum             default("unassigned"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :bigint           not null
#  language_id :bigint
#  product_id  :bigint
#
# Indexes
#
#  index_repositories_on_github_id    (github_id) UNIQUE
#  index_repositories_on_language_id  (language_id)
#  index_repositories_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

class Repository < ApplicationRecord
  acts_as_paranoid

  enum relevance: {
    commercial: 'commercial',
    internal: 'internal',
    ignored: 'ignored',
    unassigned: 'unassigned'
  }

  belongs_to :language
  belongs_to :product, optional: true

  has_many :events
  has_many :repositories,
           class_name: 'Events::Repository',
           inverse_of: :repository
  has_many :pull_requests,
           class_name: 'Events::PullRequest',
           inverse_of: :repository
  has_many :reviews,
           class_name: 'Events::Review',
           inverse_of: :repository
  has_many :review_requests,
           dependent: :destroy,
           inverse_of: :repository
  has_many :users_repositories, dependent: :destroy
  has_many :users, through: :users_repositories
  has_many :metrics, as: :ownable, dependent: :destroy

  has_many :code_owner_repositories, dependent: :destroy
  has_many :code_owners,
           through: :code_owner_repositories,
           source: :user

  has_one :code_climate_repository_metric, dependent: :destroy

  has_many :alerts, dependent: :destroy

  validates :github_id, presence: true, uniqueness: true
  validates :relevance, inclusion: { in: relevances.keys }

  before_validation :set_default_language, on: :create

  delegate :jira_board, to: :product

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
    joins(:pull_requests).where('events_pull_requests.opened_at > ?', date)
  }

  scope :with_a_pr_merged_after, lambda { |date|
    joins(:pull_requests).where('events_pull_requests.merged_at > ?', date)
  }

  scope :with_activity_before, lambda { |date|
    with_a_pr_merged_before(date).or(with_a_pr_opened_before(date))
  }

  scope :with_a_pr_opened_before, lambda { |date|
    joins(:pull_requests).where('events_pull_requests.opened_at <= ?', date)
  }

  scope :with_a_pr_merged_before, lambda { |date|
    joins(:pull_requests).where('events_pull_requests.merged_at <= ?', date)
  }

  scope :by_department, lambda { |department|
    joins(language: :department).where(departments: { id: department.id })
  }

  scope :by_language, lambda { |languages|
    joins(:language).where(languages: { name: languages })
  }

  scope :without_cc, lambda {
    left_joins(:code_climate_repository_metric).where(code_climate_repository_metrics: { id: nil })
  }

  scope :without_cc_rate, lambda {
    left_joins(:code_climate_repository_metric)
      .where(code_climate_repository_metrics: { code_climate_rate: nil })
  }

  scope :without_cc_or_cc_rate, lambda {
    without_cc.or(without_cc_rate)
  }

  RANSACK_ATTRIBUTES = %w[created_at deleted_at description github_id id id_value is_private
                          language_id name product_id relevance updated_at].freeze

  RANSACK_ASSOCIATIONS = %w[alerts code_climate_repository_metric code_owner_repositories
                            code_owners events language metrics product pull_requests repositories
                            review_requests reviews users users_repositories].freeze

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
