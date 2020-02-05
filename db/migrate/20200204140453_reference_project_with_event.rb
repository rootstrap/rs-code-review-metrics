class ReferenceProjectWithEvent < ActiveRecord::Migration[6.0]
  def change
    add_reference :events, :project, null: false
  end
end
