class GithubRepositoryClient
  URL = 'https://api.github.com/repos/rootstrap'.freeze
  LOCATIONS = ['.github/CODEOWNERS', 'docs/CODEOWNERS', 'CODEOWNERS'].freeze
  def initialize(project_name)
    @project_name = project_name
  end

  def code_owners
    ocurrences = find_in_locations
    ocurrences.detect(&:present?)
  end

  def repository_views
    connection = Faraday.new(url: "#{URL}/#{@project_name}/traffic/views") do |conn|
      conn.basic_auth(ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
    end
    response = connection.get { |request| request.params['per'] = 'week' }
    JSON.parse(response.body).with_indifferent_access
  end

  private

  def find_in_locations
    LOCATIONS.map do |location|
      connection = Faraday.new(url: "#{URL}/#{@project_name}/contents/#{location}") do |conn|
        conn.basic_auth(ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
      end
      response = connection.get { |req| req.headers['Accept'] = 'application/vnd.github.v3.raw' }
      response.success? ? response.body : ''
    end
  end
end
