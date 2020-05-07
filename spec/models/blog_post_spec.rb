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
require 'rails_helper'

RSpec.describe BlogPost, type: :model do
end
