class GithubReposApi
  URL = 'https://api.github.com/repos/rootstrap'.freeze

  def initialize(project_name)
    @project_name = project_name
  end

  def get_content_from_file(file_name)
    connection = Faraday.new(url: "#{URL}/#{@project_name}/contents/#{file_name}") do |conn|
      conn.basic_auth(ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
    end
    response = connection.get { |req| req.headers['Accept'] = 'application/vnd.github.v3.raw' }
    response.success? ? response.body : ''
  end
end
