class AddMemberTimestampsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :company_member_since, :date
    add_column :users, :company_member_until, :date

    User.where(company_member: true).find_each do |user|
      user.update(company_member_since: Date.parse('1960-10-30'))
    end
  end

  def down
    remove_column :users, :company_member_since
    remove_column :users, :company_member_until
  end
end
