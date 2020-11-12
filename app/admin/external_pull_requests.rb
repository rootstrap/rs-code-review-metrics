ActiveAdmin.register ExternalPullRequest do
  permit_params :html_url

  index do
    selectable_column
    id_column
    column :owner_id do |r|
      r.owner.login
    end
    column :external_project_id do |r|
      r.external_project.full_name
    end
    column :number
    column :title
    column :html_url
    column :github_id, label: 'Github ID'
    actions
  end

  form do |f|
    f.inputs do
      f.input :html_url, as: :string, label: 'Github URL', required: true
    end
    f.actions
  end

  controller do
    def create
      external_pull_request = Builders::ExternalPullRequest::FromUrlParams.call(
        project_full_name,
        pull_request_number
      )
      flash[:notice] = 'External Pull Request created successfully'
      redirect_to admin_external_pull_request_path external_pull_request.id
    end

    delegate :project_full_name, :pull_request_number, to: :url_parser

    def url_parser
      @url_parser ||= PullRequestUrlParser.call(params.dig('external_pull_request', 'html_url'))
    end
  end
end