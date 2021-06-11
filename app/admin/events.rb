ActiveAdmin.register Event do
  index do
    id_column
    column :name
    column :project_id do |r|
      link_to(r.project.name, admin_project_path(r.project))
    end
    column(:handleable_id, &:handleable)
  end

  filter :name
  filter :project, collection: -> { Project.order('LOWER(name)') }
  filter :handleable_type
  filter :created_at
  filter :updated_at
end
