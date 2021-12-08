FactoryBot.define do
  factory :payment do
    amount { "" }
    payed { false }
    payment_date { "2021-09-29" }
  end
end
