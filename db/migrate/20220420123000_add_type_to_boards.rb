class AddTypeToBoards < ActiveRecord::Migration[6.0]
  def change
    change_table :jira_boards do |t|
        t.string :board_type
      end
  end
end
