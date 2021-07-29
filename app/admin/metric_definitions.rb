ActiveAdmin.register MetricDefinition do
  permit_params :name, :explanation, :code

  form do |f|
    f.inputs do
      f.input :name
      f.input :code,
              as: :select,
              collection: MetricDefinition.codes.values
      f.input :explanation
    end
    f.actions
  end

  filter :code,
         as: :select,
         collection: MetricDefinition.codes.values
  filter :created_at
  filter :updated_at
end
