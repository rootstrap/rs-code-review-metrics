class PullRequestUrlParser < BaseService
  def initialize(url)
    @url = url
  end

  def call
    self
  end

  def project_full_name
    "#{url_parts[1]}/#{url_parts[2]}"
  end

  def pull_request_number
    url_parts[4].to_i
  end

  private

  attr_reader :url

  def url_parts
    url.delete_prefix('https://').split('/')
  end
end
