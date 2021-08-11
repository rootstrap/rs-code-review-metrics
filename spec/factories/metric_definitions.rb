# == Schema Information
#
# Table name: metric_definitions
#
#  id          :bigint           not null, primary key
#  code        :enum             not null
#  explanation :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :metric_definition do
    name { Faker::Name.name.gsub(' ', '') }
    code do
      %w[review_turnaround blog_visits merge_time blog_post_count
         open_source_visits defect_escape_rate pull_request_size].sample
    end
    explanation { Faker::Lorem.sentence }
  end
end
