class User < ApplicationRecord
  has_and_belongs_to_many :review_requests
  has_many :owned_review_requests, class_name: 'ReviewRequest', foreign_key: :owner_id,
           dependent: :destroy, inverse_of: :owner

end
