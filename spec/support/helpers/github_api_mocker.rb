module GithubApiMock
  def stub_get_content_of_file_not_found
    stub_request(:get, "#{GithubReposApi::URL}/new_project/contents/CODEOWNERS")
      .to_return(body: not_found_body_from_github, status: 404)
  end

  def not_found_body_from_github
    {
      'message': 'Not Found',
      'documentation_url': 'https://developer.github.com/v3/repos/contents/#get-contents'
    }.to_json
  end
end
