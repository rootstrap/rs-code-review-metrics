ActiveAdmin.register Alert do
  permit_params :name, :metric_name, :repository_id, :department_id,
                :threshold, :frequency, :active, :emails

  form do |f|
    f.inputs do
      f.input :name, required: false
      f.input :metric_name,
              as: :select,
              collection: { review_turnaround: 'review_turnaround',
                            merge_time: 'merge_time',
                            pull_request_size: 'pull_request_size' },
              required: true
      f.input :repository,
              as: :select,
              collection: Repository.order('name ASC')
      f.input :department,
              as: :select,
              collection: Department.order('name ASC')
      f.input :threshold, required: true,
                          placeholder: 'Acceptable percentage'
      f.input :frequency, placeholder: 'Week period', required: true
      f.input :active, as: :boolean, input_html: { value: 1 }
      f.input :emails, required: true, placeholder: 'List of emails separated by comma'
    end
    f.actions
  end
end
