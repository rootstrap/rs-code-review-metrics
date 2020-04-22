ActiveAdmin.register Event do
  index do
    id_column
    column :name
    column :project_id do |r|
      link_to(r.project.name, admin_project_path(r.project))
    end
    column(:handleable_id, &:handleable)
  end
end
