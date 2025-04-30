module ModalSeeDetailHelper
  def build_bar_chart_modal(repository_name, from, to)
    metrics = { metric: { from: from, to: to } }

    data = {
      'time-to-second-review': {
        url: repository_time_to_second_review_prs_repository_index_path(repository_name, metrics),
        metric: 'hours'
      },
      'time-to-merge': {
        url: repository_time_to_merge_prs_repository_index_path(repository_name, metrics),
        metric: 'hours'
      },
      'pull-request-size': {
        url: repository_pull_request_size_prs_repository_index_path(repository_name, metrics),
        metric: 'lines'
      },
      'review-coverage': {
        url: repository_review_coverage_prs_repository_index_path(repository_name, metrics),
        metric: '%'
      }
    }

    render partial: 'modal_pull_requests', locals: { request_urls: data }
  end
end
