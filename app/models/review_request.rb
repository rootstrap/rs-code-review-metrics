class ReviewRequest < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id", inverse_of: :owned_review_requests
  has_and_belongs_to_many :users
end
