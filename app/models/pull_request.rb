class PullRequest < ApplicationRecord
  has_many :review_requests, dependent: :destroy, inverse_of: :pull_requests
end
