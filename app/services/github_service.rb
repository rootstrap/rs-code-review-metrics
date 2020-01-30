class GithubService < BaseService
  include PayloadParser

  def initialize(payload)
    @payload = parse_payload(payload)
  end
end
