# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  company_member_since :date
#  company_member_until :date
#  login                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  github_id            :bigint           not null
#  node_id              :string           not null
#
# Indexes
#
#  index_users_on_github_id  (github_id) UNIQUE
#
class User < ApplicationRecord
  has_many :metrics,
           as: :ownable,
           dependent: :destroy
  has_many :owned_review_requests,
           class_name: 'ReviewRequest',
           foreign_key: :owner_id,
           dependent: :destroy,
           inverse_of: :owner
  has_many :owned_review_comments,
           class_name: 'Events::ReviewComment',
           foreign_key: :owner_id,
           dependent: :destroy,
           inverse_of: :owner
  has_many :owned_reviews,
           class_name: 'Events::Review',
           foreign_key: :owner_id,
           dependent: :destroy,
           inverse_of: :owner
  has_many :received_review_requests,
           class_name: 'ReviewRequest',
           foreign_key: :reviewer_id,
           dependent: :destroy,
           inverse_of: :reviewer
  has_many :users_projects, dependent: :destroy
  has_many :projects, through: :users_projects
  has_many :created_pull_requests,
           class_name: 'Events::PullRequest',
           dependent: :destroy,
           inverse_of: :owner
  has_many :code_owner_projects, dependent: :destroy
  has_many :projects_as_code_owner,
           through: :code_owner_projects,
           source: :project
  has_many :external_pull_requests,
           dependent: :destroy,
           foreign_key: :owner_id,
           inverse_of: :owner
  has_many :pushes,
           class_name: 'Events::Push',
           dependent: :destroy,
           inverse_of: :sender
  has_many :repositories,
           class_name: 'Events::Repository',
           dependent: :destroy,
           inverse_of: :sender
  validates :github_id,
            :login,
            :node_id,
            presence: true
  validates :github_id, uniqueness: true

  def name
    login
  end

  scope :company_member, -> { where.not(company_member_since: nil) }

  scope :members_since, lambda { |date|
    company_member.where(company_member_until: nil)
                  .or(where(company_member_until: date..Time.current))
  }
end
