class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.references :team, foreign_key: true
      t.references :payment, foreign_key: true
      t.string :name
      t.string :client_info
      t.string :project_info
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
