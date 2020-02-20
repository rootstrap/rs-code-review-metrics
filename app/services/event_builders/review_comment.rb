module EventBuilders
  class ReviewComment < EventBuilder
    def build
      comment_data = @payload['comment']
      Events::ReviewComment.find_or_create_by!(github_id: comment_data['id']) do |rc|
        rc.owner = find_or_create_user(comment_data['user'])
        rc.pull_request = find_pull_request
        rc.body = comment_data['body']
      end
    end
  end
end
