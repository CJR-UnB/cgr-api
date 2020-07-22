class CreateTeamRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :team_roles do |t|
      t.references :role, foreign_key: true
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
