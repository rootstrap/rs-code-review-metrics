# == Schema Information
#
# Table name: blog_posts
#
#  id           :bigint           not null, primary key
#  published_at :datetime
#  slug         :string
#  status       :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  blog_id      :integer
#
FactoryBot.define do
  factory :blog_post do
    sequence(:blog_id)
    slug { 'ruby-is-awesome' }
    url { 'https://www.rotstrap.com/blog/ruby_is_awesome' }
    status { BlogPost.statuses[:publish] }
    published_at { Faker::Time.backward }
  end
end
