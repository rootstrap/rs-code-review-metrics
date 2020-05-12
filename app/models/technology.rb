# == Schema Information
#
# Table name: technologies
#
#  id             :bigint           not null, primary key
#  keyword_string :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Technology < ApplicationRecord
  has_many :blog_posts, dependent: :nullify

  validates :name, uniqueness: true

  def keywords
    keyword_string.split(',')
  end

  def self.other
    find_by!(name: 'other')
  end
end
