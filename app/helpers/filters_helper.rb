module FiltersHelper
  def filter_url_query
    {
      project_name: params[:project_name],
      metric: { period: params&.dig(:metric, :period) }
    }
  end
end
