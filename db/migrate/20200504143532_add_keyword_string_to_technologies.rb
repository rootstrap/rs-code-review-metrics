class AddKeywordStringToTechnologies < ActiveRecord::Migration[6.0]
  def change
    add_column :technologies, :keyword_string, :text
  end
end
