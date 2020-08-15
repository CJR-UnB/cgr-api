class AddSoftDelete < ActiveRecord::Migration[5.2]
  def change
    change_column :member_roles, :entry_date, :datetime 
    change_column :member_roles, :leaving_date, :datetime
    remove_column :members, :entry_date
    remove_column :members, :leaving_date
    add_column    :teams,   :deleted_at, :datetime
    add_column    :roles,   :deleted_at, :datetime
    add_column    :members, :deleted_at, :datetime
  end
end
