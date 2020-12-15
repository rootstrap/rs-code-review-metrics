ActiveAdmin.register FileIgnoringRule do
  permit_params :language_id, :regex

  index do
    selectable_column
    id_column
    column :language_id do |r|
      r.language.name
    end
    column :regex
    actions
  end

  filter :regex
  filter :language, as: :select, collection: Language.order('LOWER(name)')
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :language, prompt: 'all'
      f.input :regex
    end
    f.actions
  end

  controller do
    def create
      file_ignoring_rule = params['file_ignoring_rule']

      if file_ignoring_rule['language_id'].blank?
        create_rule_for_all_languages(file_ignoring_rule['regex'])
        flash[:notice] = 'File Ignoring Rules created successfully'
        redirect_to admin_file_ignoring_rules_path
      else
        super
      end
    end

    def create_rule_for_all_languages(regex)
      Language.where.not(name: 'unassigned').each do |language|
        FileIgnoringRule.create!(
          language: language,
          regex: regex
        )
      end
    end
  end
end
