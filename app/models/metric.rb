# == Schema Information
#
# Table name: metrics
#
#  id              :bigint           not null, primary key
#  interval        :enum             default("daily")
#  name            :enum
#  ownable_type    :string           not null
#  value           :decimal(, )
#  value_timestamp :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ownable_id      :bigint           not null
#
# Indexes
#
#  index_metrics_on_ownable_type_and_ownable_id  (ownable_type,ownable_id)
#

class Metric < ApplicationRecord
  include EntityTimeRepresentation

  enum interval: { daily: 'daily', weekly: 'weekly', monthly: 'monthly', all_times: 'all_times' }
  enum name: { review_turnaround: 'review_turnaround',
               blog_visits: 'blog_visits',
               merge_time: 'merge_time',
               blog_post_count: 'blog_post_count',
               open_source_visits: 'open_source_visits' }

  belongs_to :ownable, polymorphic: true

  validates :interval, inclusion: { in: intervals.keys }
  validates :name, inclusion: { in: names.keys }
end
