module GithubApiMock
  def stub_get_content_from_file_not_found
    stub_request(:get, "#{GithubReposApi::URL}/rs-code-metrics/contents/CODEOWNERS")
      .to_return(body: not_found_body_from_github, status: 404)
  end

  def stub_get_content_from_file_ok(custom_content_file = '')
    stub_request(:get, "#{GithubReposApi::URL}/rs-code-metrics/contents/CODEOWNERS")
      .to_return(
        body: custom_content_file.presence || base_content_file,
        status: 200
      )
  end

  def not_found_body_from_github
    {
      'message': 'Not Found',
      'documentation_url': 'https://developer.github.com/v3/repos/contents/#get-contents'
    }.to_json
  end

  private

  def base_content_file
    file_fixture('code_owners_file.txt').read
  end
end
