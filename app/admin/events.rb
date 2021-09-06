ActiveAdmin.register Event do
  index do
    id_column
    column :name
    column :repository_id do |r|
      link_to(r.repository.name, admin_repository_path(r.repository))
    end
    column(:handleable_id, &:handleable)
  end

  filter :name
  filter :repository, collection: -> { Repository.order('LOWER(name)') }
  filter :handleable_type
  filter :created_at
  filter :updated_at
end
