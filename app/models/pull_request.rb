class PullRequest < ApplicationRecord
  has_many :review_requests, dependent: :destroy, inverse_of: :pull_requests

  def self.create_or_find(json)
    pr = {
      node_id: json['node_id'], number: json['number'], state: json['state'], locked: json['locked'],
      title: json['title'], body: json['body'], closed_at: json['closed_at'], merged_at: json['merged_at'],
      draft: json['draft'], merged: json['merged'], github_id: json['id']
    }
    PullRequest.create_or_find_by(pr)
  end
end
