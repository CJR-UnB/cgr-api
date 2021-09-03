class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.belongs_to :parent, foreign_key: { to_table: :teams }
      t.string :name
      t.string :initials

      t.timestamps
    end
  end
end
