class AddFlagToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :leader, :boolean
  end
end
