class GithubRepositoryClient
  URL = 'https://api.github.com/repos/rootstrap'.freeze

  def initialize(project_name)
    @project_name = project_name
  end

  def get_content_from_file(file_name)
    response = Faraday.get("#{URL}/#{@project_name}/contents/#{file_name}", {},
                           'Accept' => 'application/vnd.github.v3.raw')
    response.success? ? response.body : ''
  end

  def repository_views
    connection = Faraday.new(url: "#{URL}/#{@project_name}/traffic/views") do |conn|
      conn.basic_auth(ENV['GITHUB_ADMIN_USER'], ENV['GITHUB_ADMIN_TOKEN'])
    end
    response = connection.get
    JSON.parse(response.body).with_indifferent_access
  end
end
