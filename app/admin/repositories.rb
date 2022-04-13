ActiveAdmin.register Repository do
  permit_params :language_id, :description, :name, :github_id, :relevance, :jira_key,
                :new_jira_key, :friendly_name,
                jira_project_attributes: %i[id jira_project_key]

  index do
    selectable_column
    id_column
    column :github_id
    column :name
    column :friendly_name
    column :description
    column :language_id do |r|
      r.language.name
    end
    column :relevance
    actions
  end

  filter :name
  filter :friendly_name
  filter :is_private
  filter :github_id, label: 'GITHUB ID'
  filter :relevance, as: :select, collection: Repository.relevances.values
  filter :language, as: :select, collection: -> { Language.order('LOWER(name)') }
  filter :users, collection: -> { User.order('LOWER(login)') }
  filter :code_owners, collection: -> { User.order('LOWER(login)') }
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :github_id
      f.input :name
      f.input :friendly_name
      f.input :description, required: false
      f.input :language
      f.input :relevance, as: :radio, collection: Repository.relevances.values
    end
    f.actions
  end
end
