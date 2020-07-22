class CreateMemberTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :member_teams do |t|
      t.references :member, foreign_key: true
      t.references :team, foreign_key: true
      t.references :team_role, foreign_key: true
      t.date :entry_date
      t.date :leaving_date

      t.timestamps
    end
  end
end
