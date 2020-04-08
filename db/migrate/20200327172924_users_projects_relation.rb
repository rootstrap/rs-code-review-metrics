class UsersProjectsRelation < ActiveRecord::Migration[6.0]
  def change
    create_table :users_projects do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
    end
  end
end
