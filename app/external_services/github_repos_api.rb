class GithubReposApi
  URL = 'https://api.github.com/repos/rootstrap'.freeze

  def initialize(project_name)
    @project_name = project_name
  end

  def get_content_from_file(file_name)
    response = Faraday.get("#{URL}/#{@project_name}/contents/#{file_name}", {},
                           'Accept' => 'application/vnd.github.v3.raw')
    return response.body if response.success?

    {}
  end
end
