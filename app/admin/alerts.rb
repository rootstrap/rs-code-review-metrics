ActiveAdmin.register Alert do
  permit_params :name, :metric_name, :repository_id, :department_id,
                :threshold, :frequency, :active,
                :emails, :start_date

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs do
      f.input :name, required: false
      f.input :metric_name,
              as: :select,
              collection: MetricDefinition.codes.values,
              required: true
      f.input :repository,
              as: :select,
              collection: Repository.order('name ASC')
      f.input :department,
              as: :select,
              collection: Department.order('name ASC')
      f.input :threshold, required: true,
                          placeholder: 'Acceptable percentage'
      f.input :frequency, placeholder: 'Week period'
      f.input :active, as: :boolean, input_html: { value: 1 }
      f.input :emails, required: true, placeholder: 'List of emails separated by comma'
    end
    f.actions
  end
end
