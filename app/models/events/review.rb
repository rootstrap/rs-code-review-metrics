# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  body            :string
#  state           :enum             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_owner_id         (owner_id)
#  index_reviews_on_pull_request_id  (pull_request_id)
#  index_reviews_on_state            (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class Review < ApplicationRecord
    include EventHelper

    enum state: { approved: 'approved',
                  commented: 'commented',
                  changes_requested: 'changes_requested',
                  dismissed: 'dismissed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_reviews
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :reviews

    validates :state, inclusion: { in: states.keys }
    validates :github_id, presence: true

    ##
    # Returns the occurrence time of the 'review' event.
    ##
    def occurence_time(payload:)
      event_action = payload.fetch('action')
      review_payload = payload.fetch('review')
      case event_action
      when 'submitted'
        parse_time(review_payload.fetch('submitted_at'))
      when 'edited'
        parse_time(review_payload.fetch('edited_at'))
      when 'dismissed'
        parse_time(review_payload.fetch('dismissed_at'))
      else
        raise "Uknown action '#{event_action}'"
      end
    end

    ##
    # Parses the given time_string and returns a TimeWithZone object
    def parse_time(time_string)
      Time.zone.parse(time_string)
    end
  end
end
