ActiveAdmin.register Project do
  remove_filter :events

  index do
    id_column
    column :name
    column :description
  end
end
