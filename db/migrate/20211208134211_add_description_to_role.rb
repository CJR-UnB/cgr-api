class AddDescriptionToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :description, :text
  end
end
