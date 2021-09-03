class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.references :team, foreign_key: true     
      t.string :name

      t.timestamps
    end
  end
end
