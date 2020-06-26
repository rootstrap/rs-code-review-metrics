class CreateDepartments < ActiveRecord::Migration[6.0]
  def up
    create_table :departments do |t|

      t.timestamps
    end

    execute <<-SQL
      CREATE TYPE department_name AS ENUM ('mobile', 'frontend', 'backend');
    SQL

    add_column :departments, :name, :department_name, null: false
    add_index :departments, :name
  end

  def down
    execute <<-SQL
      DROP TYPE department_name;
    SQL

    drop_table :departments
  end
end
