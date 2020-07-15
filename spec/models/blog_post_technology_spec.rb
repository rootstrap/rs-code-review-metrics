# == Schema Information
#
# Table name: blog_post_technologies
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  blog_post_id  :bigint           not null
#  technology_id :bigint           not null
#
# Indexes
#
#  index_blog_post_technologies_on_blog_post_id   (blog_post_id)
#  index_blog_post_technologies_on_technology_id  (technology_id)
#
# Foreign Keys
#
#  fk_rails_...  (blog_post_id => blog_posts.id)
#  fk_rails_...  (technology_id => technologies.id)
#

require 'rails_helper'

RSpec.describe BlogPostTechnology, type: :model do
end
