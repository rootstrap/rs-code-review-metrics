# == Schema Information
#
# Table name: blog_posts
#
#  id            :bigint           not null, primary key
#  published_at  :datetime
#  slug          :string
#  status        :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  blog_id       :integer
#  technology_id :bigint
#
# Indexes
#
#  index_blog_posts_on_technology_id  (technology_id)
#
# Foreign Keys
#
#  fk_rails_...  (technology_id => technologies.id)
#
class BlogPost < ApplicationRecord
  enum status: {
    publish: 'publish',
    draft: 'draft',
    pending: 'pending',
    non_public: 'private',
    future: 'future',
    trash: 'trash',
    auto_draft: 'auto-draft'
  }

  belongs_to :technology

  validates :blog_id, uniqueness: true
  validates :status, inclusion: { in: statuses.keys }
end
