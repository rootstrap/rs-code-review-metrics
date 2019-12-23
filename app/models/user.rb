class User < ApplicationRecord
  has_and_belongs_to_many :review_requests
  has_many :owned_review_requests, class_name: "ReviewRequest", foreign_key: "owner_id", dependent: :destroy, inverse_of: :owner

  def self.create_or_find (json)
    User.create_or_find_by(github_id: json['id'], node_id: json['node_id'],
                           type: json['type'], login: json["login"])
  end
end
