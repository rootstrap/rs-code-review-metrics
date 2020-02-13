# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  body            :string
#  status          :enum             default("active")
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
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

module Events
  class Review < ApplicationRecord
    ACTIONS = %w[submitted edited dismissed].freeze

    enum status: { active: 'active', removed: 'removed' }

    has_many :events, as: :handleable, dependent: :destroy
    belongs_to :owner, class_name: 'User',
                       foreign_key: :owner_id,
                       inverse_of: :owned_reviews
    belongs_to :pull_request, class_name: 'Events::PullRequest',
                              inverse_of: :reviews

    validates :status, inclusion: { in: statuses.keys }
    validates :github_id, presence: true

    attr_accessor :payload

    def resolve
      return unless handleable?

      handle_action
    end

    private

    def handle_action
      send(payload['action'])
    end

    def find_or_create_user(user_data)
      User.find_or_create_by!(github_id: user_data['id']) do |user|
        user.node_id = user_data['node_id']
        user.login = user_data['login']
      end
    end

    def find_or_create_review(payload)
      review_data = payload['review']
      review = Events::Review.find_or_create_by!(github_id: review_data['id']) do |rc|
        rc.owner = find_or_create_user(review_data['user'])
        rc.pull_request = Events::PullRequest.find_by!(github_id: payload['pull_request']['id'])
      end
      review.assign_attributes(payload: payload)
      review
    end

    def handleable?
      ACTIONS.include?(payload['action'])
    end

    # Actions

    def submitted
      update!(body: payload['review']['body'])
    end

    def edited
      update!(body: payload['changes']['body'])
    end

    def dismissed
      removed!
    end
  end
end
