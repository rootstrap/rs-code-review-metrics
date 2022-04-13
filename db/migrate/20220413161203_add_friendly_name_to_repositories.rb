class AddFriendlyNameToRepositories < ActiveRecord::Migration[6.0]
  def change
    change_table :repositories do |t|
      t.string :friendly_name
    end
  end
end
