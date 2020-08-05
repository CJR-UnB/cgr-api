class CreateMemberRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :member_roles do |t|
      t.references :member, foreign_key: true
      t.references :role, foreign_key: true
      t.date :entry_date
      t.date :leaving_date

      t.timestamps
    end
  end
end
