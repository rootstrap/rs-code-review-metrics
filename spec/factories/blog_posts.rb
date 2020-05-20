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
FactoryBot.define do
  factory :blog_post do
    blog_id { 1111 }
    slug { 'ruby-is-awesome' }
    url { 'https://www.rotstrap.com/blog/ruby_is_awesome' }
    status { BlogPost.statuses[:publish] }
    published_at { Faker::Time.backward }

    association :technology
  end
end
