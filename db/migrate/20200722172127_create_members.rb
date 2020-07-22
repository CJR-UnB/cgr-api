class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.date :entry_date
      t.date :leaving_date

      t.timestamps
    end
  end
end
