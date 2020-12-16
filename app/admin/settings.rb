ActiveAdmin.register Setting do
  permit_params :key, :value, :description
end
