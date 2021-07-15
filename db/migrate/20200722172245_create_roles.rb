class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.belongs_to :parent, foreign_key: { to_table :roles }
      t.references :team, foreign_key: true     
      t.string :name

      t.timestamps
    end
  end
end
