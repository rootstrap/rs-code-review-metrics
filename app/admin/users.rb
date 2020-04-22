ActiveAdmin.register User do
  index do
    id_column
    column :login
  end
end
