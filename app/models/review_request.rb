# == Schema Information
#
# Table name: review_requests
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  event_type      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :bigint
#  pull_request_id :bigint           not null
#
# Indexes
#
#  index_review_requests_on_owner_id         (owner_id)
#  index_review_requests_on_pull_request_id  (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

class ReviewRequest < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id, inverse_of: :owned_review_requests
  belongs_to :pull_request, inverse_of: :review_requests
  has_and_belongs_to_many :users
end
