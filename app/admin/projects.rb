ActiveAdmin.register Project do
  index do
    id_column
    column :name
    column :description
    column :lang
  end
end
