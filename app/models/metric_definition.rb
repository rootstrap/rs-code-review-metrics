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

class MetricDefinition < ApplicationRecord
  enum code: { review_turnaround: 'review_turnaround',
               blog_visits: 'blog_visits',
               merge_time: 'merge_time',
               blog_post_count: 'blog_post_count',
               open_source_visits: 'open_source_visits',
               defect_escape_rate: 'defect_escape_rate',
               pull_request_size: 'pull_request_size',
               development_cycle: 'development_cycle',
               planned_to_done: 'planned_to_done',
               review_coverage: 'review_coverage' }

  validates :code, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :explanation, presence: true

  RANSACK_ATTRIBUTES = %w[code created_at id id_value name updated_at].freeze
end
