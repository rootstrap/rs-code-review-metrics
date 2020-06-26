class AddProjectLanguageRelation < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :language
  end
end
