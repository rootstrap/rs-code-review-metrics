module MetaTagsHelper
  def meta_title
    if current_page?(products_development_metrics_path)
      return product_name.present? ? product_metrics_title : default_description
    end

    if current_page?(products_metrics_development_metrics_path)
      return product_name + ' - ' + metric_definition_name
    end

    title_for_pages
  end

  def meta_description
    if current_page?(products_development_metrics_path)
      product_name.present? ? product_summary_description : default_description
    elsif current_page?(products_metrics_development_metrics_path)
      product_description
    elsif current_page?(repositories_development_metrics_path)
      I18n.t('helpers.meta_tags.repository_metrics_title', repository_name: @repository[:name])
    else
      description_for_pages
    end
  end

  def meta_image
    generate_url_image if current_page?(products_metrics_development_metrics_path)
  end

  private

  def product_metrics_title
    I18n.t('helpers.meta_tags.products_metrics_title', product_name: product_name)
  end

  def metric_definition_name
    MetricDefinition.where(code: @query_metric_name).first&.name
  end

  def title_for_pages
    if current_page?(repositories_development_metrics_path)
      I18n.t('helpers.meta_tags.repository_metrics_title', repository_name: @repository[:name])
    elsif current_page?(open_source_index_path)
      I18n.t('helpers.meta_tags.open_source_title')
    elsif current_page?(departments_development_metrics_path)
      department_title
    elsif current_page?(tech_blog_path)
      I18n.t('helpers.meta_tags.tech_blog_title')
    else
      default_description
    end
  end

  def description_for_pages
    if current_page?(open_source_index_path)
      "#{@total_repositories} open source #{'repository'.pluralize(@total_repositories)}"
    elsif current_page?(departments_development_metrics_path)
      if @department.present?
        I18n.t('helpers.meta_tags.departments_title', department_name: @department[:name])
      else
        I18n.t('helpers.meta_tags.default_departments_title')
      end
    elsif current_page?(tech_blog_path)
      I18n.t('helpers.meta_tags.tech_blog_description', month_to_date_visits: @month_to_date_visits)
    else
      default_description
    end
  end

  def product_name
    @product_name ||= @product[:name] if @product.present?
  end

  def default_description
    I18n.t('helpers.meta_tags.default_description')
  end

  def department_title
    if @department.present?
      I18n.t('helpers.meta_tags.departments_title', department_name: @department[:name])
    else
      I18n.t('helpers.meta_tags.default_departments_title')
    end
  end

  def product_description
    separator?(false)

    description = ''

    description += defect_escape_rate_description if defect_escape_rate_description.present?
    description += development_cycle_description if development_cycle_description.present?
    description += planned_to_done_description if planned_to_done_description.present?

    description = default_description if description.nil?

    description
  end

  def product_summary_description
    separator?(true)

    description = 'Summary - '

    description += defect_escape_rate_description if defect_escape_rate_description.present?
    description += development_cycle_description if development_cycle_description.present?
    description += planned_to_done_description if planned_to_done_description.present?

    description = default_description if description == 'Summary - '

    description
  end

  def defect_escape_rate_description
    return unless @show_defect_escape_rate

    data = @defect_escape_rate[:per_defect_escape_values].first[:data]

    return unless @show_defect_escape_rate && data.present?

    desc = 'Overall ' + @defect_escape_rate_definition.name + ': ' + data[:rate].to_s + '%'
    desc += ' -' if @separator
    desc
  end

  def development_cycle_description
    return unless @show_development_cycle

    average = @development_cycle[:per_development_cycle_average].first[:data][:average]

    return if average.blank?

    desc = 'Overall ' + @development_cycle_definition.name + ': ' + average.to_s + '%'
    desc += ' -' if @separator
    desc
  end

  def planned_to_done_description
    return unless @show_planned_to_done

    data = @planned_to_done[:per_planned_to_done_average].first[:data]

    return if data.blank?

    'Overall ' + @planned_to_done_definition.name + ': ' + data[:average].to_s + '%'
  end

  def separator?(separator)
    @separator = separator
  end

  def generate_url_image
    defect_escape_rate_image || development_cycle_image || planned_to_done_image
  end

  def defect_escape_rate_image
    return unless @show_defect_escape_rate

    data = @defect_escape_rate[:per_defect_escape_values].first[:data]

    return unless @show_defect_escape_rate && data.present?

    Builders::Chartkick::GenerateChartImage
      .new(@product[:name], data, '%', 'bar').generate_url
  end

  def development_cycle_image
    return unless @show_development_cycle

    data = @development_cycle[:per_development_cycle_values].first[:data]

    return if data.blank?

    Builders::Chartkick::GenerateChartImage
      .new(@product[:name], data, 'days', 'line').generate_url
  end

  def planned_to_done_image
    return unless @show_planned_to_done

    data = @planned_to_done[:per_planned_to_done_values].first[:data]

    return if data.blank?

    Builders::Chartkick::GenerateChartImage
      .new(@product[:name], planned_to_done_values, 'points', 'bar').generate_url_mutiple_bar
  end

  def planned_to_done_values
    @planned_to_done[:per_planned_to_done_values]
      .first[:data]
      .group_by { |sprint| sprint[:name] }
      .map do |label, points|
        {
          name: label,
          data: points.map { |sprint| sprint[:data] }.reduce(&:merge)
        }
      end
  end
end
