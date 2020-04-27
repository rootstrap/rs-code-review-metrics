# == Schema Information
#
# Table name: technologies
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Technology < ApplicationRecord
  has_many :blog_posts, dependent: :nullify
end
