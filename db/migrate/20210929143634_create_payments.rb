class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.boolean :payed
      t.date :payment_date

      t.timestamps
    end
  end
end
