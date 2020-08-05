module RequestsHelper
  def content_url(resource)
    request.original_url.match(resource)
  end
end
