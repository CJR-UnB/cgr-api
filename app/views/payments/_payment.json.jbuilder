json.extract! payment, :id, :amount, :payed, :payment_date, :created_at, :updated_at
json.url payment_url(payment, format: :json)
