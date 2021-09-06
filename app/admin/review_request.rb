ActiveAdmin.register ReviewRequest do
  index do
    id_column
    column :status
    column :owner_id do |r|
      link_to(r.owner.login, admin_user_path(r.owner))
    end
    column :pull_request_id do |r|
      link_to(r.pull_request.title, admin_event_path(r.pull_request))
    end
    column :reviewer_id do |r|
      link_to(r.reviewer.login, admin_user_path(r.reviewer))
    end
  end

  filter :owner, collection: -> { User.order('LOWER(login)') }
  filter :reviewer, collection: -> { User.order('LOWER(login)') }
  filter :repository, collection: -> { Repository.order('LOWER(name)') }
  filter :created_at
  filter :updated_at
end
